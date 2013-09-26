Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51277 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3IZFqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 01:46:18 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so224482bkb.38
        for <linux-wireless@vger.kernel.org>; Wed, 25 Sep 2013 22:46:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130925210848.2596.56332.stgit@localhost6.localdomain6>
References: <20130925210455.2596.36889.stgit@localhost6.localdomain6>
	<20130925210848.2596.56332.stgit@localhost6.localdomain6>
Date: Thu, 26 Sep 2013 07:46:16 +0200
Message-ID: <CA+BoTQ=BhtjC1YNLs9OYBPN6TiYhyrwYoK2A1wifS01HVJp1YA@mail.gmail.com> (sfid-20130926_074621_480692_04BD3240)
Subject: Re: [PATCH 3/3] ath10k: implement firmware IE container support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2013 23:08, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> +static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
> +{
> +       size_t magic_len, len, ie_len;
> +       struct ath10k_fw_ie *hdr;
> +       const u8 *data;
> +       int ie_id, i, index, bit;
> +       __le32 *timestamp;
> +
> +       ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
> +       if (IS_ERR(ar->firmware)) {
> +               ath10k_err("Could not fetch firmware file '%s': %ld\n",
> +                          name, PTR_ERR(ar->firmware));
> +               return PTR_ERR(ar->firmware);
> +       }
> +
> +       data = ar->firmware->data;
> +       len = ar->firmware->size;
> +
> +       /* magic also includes the null byte, check that as well */
> +       magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
> +
> +       if (len < magic_len) {
> +               ath10k_err("firmware image too small to contain magic: %d\n",
> +                          len);
> +               return -EINVAL;
> +       }
> +
> +       if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
> +               ath10k_err("Invalid firmware magic\n");
> +               return -EINVAL;
> +       }
> +
> +       /* jump over the padding */
> +       magic_len = ALIGN(magic_len, 4);
> +
> +       len -= magic_len;
> +       data += magic_len;
> +
> +       /* loop elements */
> +       while (len > sizeof(struct ath10k_fw_ie)) {
> +               hdr = (struct ath10k_fw_ie *)data;
> +
> +               ie_id = le32_to_cpu(hdr->id);
> +               ie_len = le32_to_cpu(hdr->len);
> +
> +               len -= sizeof(*hdr);
> +               data += sizeof(*hdr);
> +
> +               if (len < ie_len) {
> +                       ath10k_err("Invalid length for FW IE %d (%d < %d)\n",
> +                                  ie_id, len, ie_len);
> +                       return -EINVAL;
> +               }
> +
> +               switch (ie_id) {
> +               case ATH10K_FW_IE_FW_VERSION:
> +                       if (ie_len > sizeof(ar->hw->wiphy->fw_version) - 1)
> +                               break;
> +
> +                       memcpy(ar->hw->wiphy->fw_version, data, ie_len);
> +                       ar->hw->wiphy->fw_version[ie_len] = '\0';
> +
> +                       ath10k_dbg(ATH10K_DBG_BOOT,
> +                                  "found fw version %s\n",
> +                                   ar->hw->wiphy->fw_version);
> +                       break;
> +               case ATH10K_FW_IE_TIMESTAMP:
> +                       if (ie_len != sizeof(u32))
> +                               break;
> +
> +                       timestamp = (__le32 *)data;
> +
> +                       ath10k_dbg(ATH10K_DBG_BOOT, "found fw timestamp %d\n",
> +                                  le32_to_cpup(timestamp));
> +                       break;
> +               case ATH10K_FW_IE_FEATURES:
> +                       ath10k_dbg(ATH10K_DBG_BOOT,
> +                                  "found firmware features ie (%zd B)\n",
> +                                  ie_len);
> +
> +                       for (i = 0; i < ATH10K_FW_FEATURE_COUNT; i++) {
> +                               index = i / 8;
> +                               bit = i % 8;
> +
> +                               if (index == ie_len)
> +                                       break;
> +
> +                               if (data[index] & (1 << bit))
> +                                       __set_bit(i, ar->fw_features);
> +                       }
> +
> +                       ath10k_dbg_dump(ATH10K_DBG_BOOT, "features", "",
> +                                       ar->fw_features,
> +                                       sizeof(ar->fw_features));
> +                       break;
> +               case ATH10K_FW_IE_FW_IMAGE:
> +                       ath10k_dbg(ATH10K_DBG_BOOT,
> +                                  "found fw image ie (%zd B)\n",
> +                                  ie_len);
> +
> +                       ar->firmware_data = data;
> +                       ar->firmware_len = ie_len;
> +
> +                       break;
> +               case ATH10K_FW_IE_OTP_IMAGE:
> +                       ath10k_dbg(ATH10K_DBG_BOOT,
> +                                  "found otp image ie (%zd B)\n",
> +                                  ie_len);
> +
> +                       ar->otp_data = data;
> +                       ar->otp_len = ie_len;
> +
> +                       break;
> +               default:
> +                       ath10k_warn("Unknown FW IE: %u\n",
> +                                   le32_to_cpu(hdr->id));
> +                       break;
> +               }
> +
> +               /* jump over the padding */
> +               ie_len = ALIGN(ie_len, 4);
> +
> +               len -= ie_len;
> +               data += ie_len;
> +       };
> +
> +       return 0;
> +}
> +
> +static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
> +{
> +       int ret;
> +
> +       ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
> +       if (ret == 0) {
> +               ar->fw_api = 2;
> +               goto out;
> +       }

Did you skip board file intentionally?


Michał.
