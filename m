Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18965 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbEHLzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 07:55:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com>
Date: Fri, 8 May 2015 14:54:58 +0300
In-Reply-To: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com>
	(Liu CF's message of "Tue, 5 May 2015 18:06:46 -0700")
Message-ID: <873837qo6l.fsf@kamboji.qca.qualcomm.com> (sfid-20150508_135517_307858_DBD54D1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

"Liu CF/TW" <cfliu.tw@gmail.com> writes:

>  - ath10k:   add rawtxrx param for 10.2+ firmware to support sw, hw crypto
>              engine and raw Tx injection.
>  - mac80211: Add IEEE80211_KEY_FLAG_RESERVE_TAILROOM support for TKIP and
>              CCMP required by ath10k and add per BSS(vif) based sw_crypto
>              control.

This patch has few major problems. First of all, ath10k and mac80211
changes should be in separate patches. Secondly the patch is whitespace
damaged, I recommend using git-send-email to avoid that.

And there's just too much feature changes in one patch, it's usually
better to split the features into separate patches. For example, you
could first add a simple raw mode support to ath10k (ie. the bare
minimum needed to get the feature) and then adding more advanced
features per patch.

> This change enables the raw Tx/Rx feature in ath10k 10.2+ firmware with a
> module parameter 'rawtxrx'. With rawtxrx=1, the ath10k hardware crypto
> engine could be optionally skipped to support use cases such as enabling
> mac80211 sw crypto engine, user level crypto engine, raw Tx frame
> injection.

Lots of people, especially in Qualcomm, seem to call this feature as
"raw mode". Would it be more descriptive to name the module paramer as
'rawmode'?

> Testing: used QCA988x hw 2.0 with 10.2 firmware.
>
> ath10k    ath10k     nl80211
> rawtxrx   nohwcrypt  SW_CRYPTO
> param     param      attribute    Testing Status
> -------   ---------  ---------    ---------------------------------
>    0          0           -         HW CCMP/TKIP tested ok.
>    0          1           -         Not supported by ath10k hw.
>    1          0           -         HW CCMP/TKIP tested ok.
>    1          0           0         BSS 1 tested HW CCMP/TKIP ok.
>    1          0           1         BSS 2 can bypass HW engine.
>                                     - mac80211 SW crypto tested ok.
>                                     - raw Tx frame injection tested ok.
>    1          1           -         HW crypto globally disabled.
>                                     - mac80211 SW crypto tested ok.
>                                     - raw Tx frame injection tested ok.

I wonder does it make any sense to have nohwcrypt parameter? Especially
if ath10k doesn't support case rawtxrx=0 and nohwcrypt=1. One
possibility I came up is to have multiple values for rawtxrx, for
example is rawtxrx=1 means HW crypt enabled and rawtxrx=2 HW crypt
disabled. Ideas welcome.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -31,16 +31,22 @@
>  #include "wmi-ops.h"
>
>  unsigned int ath10k_debug_mask;
> +bool ath10k_modparam_nohwcrypt;
> +bool ath10k_modparam_rawtxrx;

Instead of making these public I would prefer to set a flag in struct
ath10k, for example dev_flags.

> ath10k_core_init_firmware_features(struct ath10k *ar)
>   return -EINVAL;
>   }
>
> + if ((ath10k_modparam_rawtxrx || ath10k_modparam_nohwcrypt) &&
> +    !test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features)) {
> + ath10k_err(ar, "rawtxrx mode supported only in 10.2+ firmware");
> + return -EINVAL;
> + }

I think we should add a flag to enum ath10k_fw_features and check for
that.

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 241220c..cdfa8a8 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1761,6 +1761,9 @@ enum nl80211_commands {
>   * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
>   *      is operating in an indoor environment.
>   *
> + * @NL80211_ATTR_SW_CRYPTO: use software crypto instead of hardware crypto for
> + * the BSS.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2130,6 +2133,8 @@ enum nl80211_attrs {
>
>   NL80211_ATTR_REG_INDOOR,
>
> + NL80211_ATTR_SW_CRYPTO,

Like I said above, nl80211/cfg80211/mac80211 changes need to be in
separate patches. And I suspect that the changes of getting this
accepted is low. Maybe a debugfs is a better choise?

-- 
Kalle Valo
