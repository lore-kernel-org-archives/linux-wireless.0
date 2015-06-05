Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37423 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbFELwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 07:52:08 -0400
Received: by wifx6 with SMTP id x6so17962544wif.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 04:52:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com>
References: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com>
Date: Fri, 5 Jun 2015 13:52:07 +0200
Message-ID: <CA+BoTQm-Ya6anRxgJShQq4SGWwkZbayeQJPCPn8YOr=0zTbxyw@mail.gmail.com> (sfid-20150605_135213_273759_BFA7ED36)
Subject: Re: [PATCH V2] ath10k: add 'cryptmode' param to support raw tx
 injection and sw crypto.
From: Michal Kazior <michal.kazior@tieto.com>
To: "Liu CF/TW" <cfliu.tw@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 June 2015 at 19:47, Liu CF/TW <cfliu.tw@gmail.com> wrote:
[...]
> @@ -991,6 +994,32 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>                 return -EINVAL;
>         }
>
> +       switch (ath10k_cryptmode_param) {
> +       case ATH10K_CRYPT_MODE_HW:
> +               clear_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
> +               clear_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
> +               break;
> +       case ATH10K_CRYPT_MODE_SW:
> +       case ATH10K_CRYPT_MODE_HW_SW:
> +               if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
> +                             ar->fw_features)) {
> +                       ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
> +                       return -EINVAL;
> +               }
> +
> +               set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
> +
> +               if (ath10k_cryptmode_param == ATH10K_CRYPT_MODE_SW) {
> +                       set_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
> +               }
> +               break;
> +       default:
> +               ath10k_info(ar, "invalid cryptmode: %d\n",
> +                           ath10k_cryptmode_param);
> +               return -EINVAL;
> +       }
> +       ath10k_info(ar, "cryptmode: %d\n", ath10k_cryptmode_param);

This may be a bit too verbose. I was actually thinking of adding this
to the ath10k_print_driver_info().


[...]
>  static int ath10k_install_key(struct ath10k_vif *arvif,
> @@ -3172,9 +3184,24 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
>         if (ieee80211_is_data_present(fc) && sta && sta->tdls)
>                 return ATH10K_HW_TXRX_ETHERNET;
>
> +       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
> +               return ATH10K_HW_TXRX_RAW;

This means not all traffic will go RAW. The TDLS case above will use
ethernet encap. I'm aware you might not have the hardware to test that
though.. Might be worth putting a FIXME at least.


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 77220b0..64b31f1 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -3894,7 +3894,9 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
>         config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
>         config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
>         config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
> -       config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
> +       config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_NATIVE_WIFI);
> +       if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
> +               config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_RAW);

If 636, 10.1 or wmi-tlv firmware revisions were to advertise RAW mode
support in the future rx_decap_mode won't be set correctly because you
only update the 10.2 op_gen_init code.

All TARGET_*RX_DECAP_MODE should be removed from hw.h and
ar->wmi.rx_decap_mode should be introduced which is set somewhere in
ath10k_core_init_firmware_features() and used throughout all
op_gen_init implementations.


Michał
