Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36991 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbJUHWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 03:22:36 -0400
Received: by wicfv8 with SMTP id fv8so61023836wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 00:22:34 -0700 (PDT)
Message-ID: <56273D3F.6080804@gmail.com> (sfid-20151021_092240_456785_055697E2)
Date: Wed, 21 Oct 2015 12:52:39 +0530
From: Manikanta <manikanta.pubbisetty@gmail.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add FW API support to test mode
References: <20151020112513.14879.47438.stgit@potku.adurom.net>	<5625E6BD.6020307@gmail.com> <CA+BoTQnSQmdCCqF43+Q5cxyVVLrM_BxRMT+Ydpfe6_5yRV2+Lw@mail.gmail.com>
In-Reply-To: <CA+BoTQnSQmdCCqF43+Q5cxyVVLrM_BxRMT+Ydpfe6_5yRV2+Lw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wednesday 21 October 2015 12:36 PM, Michal Kazior wrote:
> On 20 October 2015 at 09:01, Manikanta Pubbisetty
> <manikanta.pubbisetty@gmail.com> wrote:
>>
>> On 10/20/2015 04:55 PM, Kalle Valo wrote:
>>> From: Alan Liu <alanliu@qca.qualcomm.com>
>>>
>>> Add WMI-TLV and FW API support in ath10k testmode.
>>> Ath10k can get right wmi command format from UTF image
>>> to communicate UTF firmware.
>>>
>>> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>> ---
>>>    drivers/net/wireless/ath/ath10k/core.c     |    4 -
>>>    drivers/net/wireless/ath/ath10k/core.h     |    5 +
>>>    drivers/net/wireless/ath/ath10k/hw.h       |    1
>>>    drivers/net/wireless/ath/ath10k/testmode.c |  202
>>> ++++++++++++++++++++++++++--
>>>    drivers/net/wireless/ath/ath10k/wmi-tlv.c  |   14 ++
>>>    5 files changed, 205 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/core.c
>>> b/drivers/net/wireless/ath/ath10k/core.c
>>> index 13de3617d5ab..b7a82ae3b3fa 100644
>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>> @@ -568,8 +568,8 @@ static int ath10k_download_fw(struct ath10k *ar, enum
>>> ath10k_firmware_mode mode)
>>>                  }
>>>                  break;
>>>          case ATH10K_FIRMWARE_MODE_UTF:
>>> -               data = ar->testmode.utf->data;
>>> -               data_len = ar->testmode.utf->size;
>>> +               data = ar->testmode.utf_firmware_data;
>>> +               data_len = ar->testmode.utf_firmware_len;
>>>                  mode_name = "utf";
>>>                  break;
>>>          default:
>>> diff --git a/drivers/net/wireless/ath/ath10k/core.h
>>> b/drivers/net/wireless/ath/ath10k/core.h
>>> index 7cc7cdd56c95..a6371108be9b 100644
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -814,9 +814,12 @@ struct ath10k {
>>>          struct {
>>>                  /* protected by conf_mutex */
>>>                  const struct firmware *utf;
>>> +               char utf_version[32];
>>> +               const void *utf_firmware_data;
>>> +               size_t utf_firmware_len;
>>>                  DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
>>>                  enum ath10k_fw_wmi_op_version orig_wmi_op_version;
>>> -
>>> +               enum ath10k_fw_wmi_op_version op_version;
>>>                  /* protected by data_lock */
>>>                  bool utf_monitor;
>>>          } testmode;
>>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h
>>> b/drivers/net/wireless/ath/ath10k/hw.h
>>> index 2d87737e35ff..0c8ea0226684 100644
>>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>>> @@ -94,6 +94,7 @@ enum qca6174_chip_id_rev {
>>>    #define ATH10K_FW_API5_FILE           "firmware-5.bin"
>>>
>>>    #define ATH10K_FW_UTF_FILE            "utf.bin"
>>> +#define ATH10K_FW_UTF_API2_FILE                "utf-2.bin"
>>>
>>>    /* includes also the null byte */
>>>    #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
>>> diff --git a/drivers/net/wireless/ath/ath10k/testmode.c
>>> b/drivers/net/wireless/ath/ath10k/testmode.c
>>> index b084f88da102..1d5a2fdcbf56 100644
>>> --- a/drivers/net/wireless/ath/ath10k/testmode.c
>>> +++ b/drivers/net/wireless/ath/ath10k/testmode.c
>>> @@ -139,11 +139,181 @@ static int ath10k_tm_cmd_get_version(struct ath10k
>>> *ar, struct nlattr *tb[])
>>>          return cfg80211_testmode_reply(skb);
>>>    }
>>>
>>> -static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr
>>> *tb[])
>>> +static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
>>> +{
>>> +       size_t len, magic_len, ie_len;
>>> +       struct ath10k_fw_ie *hdr;
>>> +       char filename[100];
>>> +       __le32 *version;
>>> +       const u8 *data;
>>> +       int ie_id, ret;
>>> +
>>> +       snprintf(filename, sizeof(filename), "%s/%s",
>>> +                ar->hw_params.fw.dir, ATH10K_FW_UTF_API2_FILE);
>>> +
>>> +       /* load utf firmware image */
>>> +       ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
>>> +       if (ret) {
>>> +               ath10k_warn(ar, "failed to retrieve utf firmware '%s':
>>> %d\n",
>>> +                           filename, ret);
>>> +               return ret;
>>> +       }
>>> +
>>> +       data = ar->testmode.utf->data;
>>> +       len = ar->testmode.utf->size;
>>> +
>>> +       /* FIXME: call release_firmware() in error cases */
>>> +
>>> +       /* magic also includes the null byte, check that as well */
>>> +       magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
>>> +
>>> +       if (len < magic_len) {
>>> +               ath10k_err(ar, "utf firmware file is too small to contain
>>> magic\n");
>>> +               ret = -EINVAL;
>>> +               goto err;
>>> +       }
>>> +
>>> +       if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
>>> +               ath10k_err(ar, "invalid firmware magic\n");
>>> +               ret = -EINVAL;
>>> +               goto err;
>>> +       }
>>> +
>>> +       /* jump over the padding */
>>> +       magic_len = ALIGN(magic_len, 4);
>>> +
>>> +       len -= magic_len;
>>> +       data += magic_len;
>>> +
>>> +       /* loop elements */
>>> +       while (len > sizeof(struct ath10k_fw_ie)) {
>>> +               hdr = (struct ath10k_fw_ie *)data;
>>> +
>>> +               ie_id = le32_to_cpu(hdr->id);
>>> +               ie_len = le32_to_cpu(hdr->len);
>>> +
>>> +               len -= sizeof(*hdr);
>>> +               data += sizeof(*hdr);
>>> +
>>> +               if (len < ie_len) {
>>> +                       ath10k_err(ar, "invalid length for FW IE %d (%zu <
>>> %zu)\n",
>>> +                                  ie_id, len, ie_len);
>>> +                       ret = -EINVAL;
>>> +                       goto err;
>>> +               }
>>> +
>>> +               switch (ie_id) {
>>> +               case ATH10K_FW_IE_FW_VERSION:
>>
>> Something like ATH10K_UTF_IE_FW_VERSION or ATH10K_TESTMODE_IE_FW_VERSION
>> would be less confusing and better, isn't it?
> I don't really see a reason to. UTF is just another main program to
> run on the device.
>
> If anything I would suggest to unify the FW API parsing logic to work
> with a dedicated structure instead of `struct ath10k` directly, i.e.
>
>    struct ath10k_fw {
>      void *data;
>      size_t data_len;
>      enum wmi_op_version wmi_op_version;
>      // ...
>    };
>
>    int ath10k_core_fw_api_parse(struct ath10k *ar,
>                                 struct ath10k_fw *arfw,
>                                 struct firmware *fw)
>     {
>       // parse and fill in `arfw`
>     }
>
>    struct ath10k {
>      // ...
>      struct ath10k_fw fw_normal;
>      struct ath10k_fw fw_utf;
>      // ...
>    };
>
>
> Michał
Hmmm, this way we will have a unified firmware parsing logic. Is this a 
task which can be taken up easily or any other hidden complexities are 
invloved ?.
I mean can we do the changes for current parsing logic and then rework 
the test mode patch ? what is your suggestion ?

-Manikanta
