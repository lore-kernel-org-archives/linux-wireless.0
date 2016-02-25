Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38775 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbcBYBGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:06:44 -0500
Received: by mail-ig0-f178.google.com with SMTP id y8so3432864igp.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:06:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-5-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-5-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:06:24 +1100
Message-ID: <CAGRGNgVHvB1Vex4+WvvFg7b8+M4ESrT1fFpiO22aX2k1a_Fjmg@mail.gmail.com> (sfid-20160225_020653_214609_3B29CF8F)
Subject: Re: [PATCH 4/7] mwifiex: scan: factor out dbg_security_flags
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> merge copy/paste code

The code you delete isn't all equivalent. I'll explain below.

> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 73 ++++++++++-------------------
>  1 file changed, 24 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index f612c1b..5588750 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -76,6 +76,26 @@ static u8 mwifiex_rsn_oui[CIPHER_SUITE_MAX][4] = {
>         { 0x00, 0x0f, 0xac, 0x04 },     /* AES  */
>  };
>
> +static void
> +_dbg_security_flags(int log_level, struct mwifiex_private *priv,
> +                   struct mwifiex_bssdescriptor *bss_desc)
> +{
> +       _mwifiex_dbg(priv->adapter, log_level,
> +                    "info: %s: WPA:\twpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\tEncMode=%#x privacy=%#x\n",
> +                    __func__,

After the __func__, "WPA:" is printed in your new common function

> +                    bss_desc->bcn_wpa_ie ?
> +                    bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> +                    bss_desc->bcn_rsn_ie ?
> +                    bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
> +                    priv->sec_info.wep_enabled ? "e" : "d",
> +                    priv->sec_info.wpa_enabled ? "e" : "d",
> +                    priv->sec_info.wpa2_enabled ? "e" : "d",
> +                    priv->sec_info.encryption_mode,
> +                    bss_desc->privacy);
> +}
> +#define dbg_security_flags(mask, priv, bss_desc) \
> +       _dbg_security_flags(MWIFIEX_DBG_##mask, priv, bss_desc)
> +
>  static bool
>  has_ieee_hdr(struct ieee_types_generic *ie, u8 key)
>  {
> @@ -243,19 +263,7 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
>             * LinkSys WRT54G && bss_desc->privacy
>             */
>          ) {
> -               mwifiex_dbg(priv->adapter, INFO,
> -                           "info: %s: WPA:\t"

which is the same as here

> -                           "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
> -                           "EncMode=%#x privacy=%#x\n", __func__,
> -                           bss_desc->bcn_wpa_ie ?
> -                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> -                           bss_desc->bcn_rsn_ie ?
> -                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
> -                           (priv->sec_info.wep_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa2_enabled) ? "e" : "d",
> -                           priv->sec_info.encryption_mode,
> -                           bss_desc->privacy);
> +               dbg_security_flags(INFO, priv, bss_desc);
>                 return true;
>         }
>         return false;
> @@ -276,19 +284,7 @@ mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
>                  * Privacy bit may NOT be set in some APs like
>                  * LinkSys WRT54G && bss_desc->privacy
>                  */
> -               mwifiex_dbg(priv->adapter, INFO,
> -                           "info: %s: WPA2:\t"

but we print "WPA2:" here,

> -                           "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
> -                           "EncMode=%#x privacy=%#x\n", __func__,
> -                           bss_desc->bcn_wpa_ie ?
> -                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> -                           bss_desc->bcn_rsn_ie ?
> -                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
> -                           (priv->sec_info.wep_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa2_enabled) ? "e" : "d",
> -                           priv->sec_info.encryption_mode,
> -                           bss_desc->privacy);
> +               dbg_security_flags(INFO, priv, bss_desc);
>                 return true;
>         }
>         return false;
> @@ -325,17 +321,7 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
>             !has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC) &&
>             !has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN) &&
>             priv->sec_info.encryption_mode && bss_desc->privacy) {
> -               mwifiex_dbg(priv->adapter, INFO,
> -                           "info: %s: dynamic\t"

"dynamic" here,

> -                           "WEP: wpa_ie=%#x wpa2_ie=%#x\t"
> -                           "EncMode=%#x privacy=%#x\n",
> -                           __func__,
> -                           bss_desc->bcn_wpa_ie ?
> -                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> -                           bss_desc->bcn_rsn_ie ?
> -                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
> -                           priv->sec_info.encryption_mode,
> -                           bss_desc->privacy);
> +               dbg_security_flags(INFO, priv, bss_desc);
>                 return true;
>         }
>         return false;
> @@ -448,18 +434,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
>                 }
>
>                 /* Security doesn't match */
> -               mwifiex_dbg(adapter, ERROR,
> -                           "info: %s: failed: wpa_ie=%#x wpa2_ie=%#x WEP=%s\t"

and "failed" here.

> -                           "WPA=%s WPA2=%s EncMode=%#x privacy=%#x\n",
> -                           __func__,
> -                           bss_desc->bcn_wpa_ie ?
> -                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> -                           bss_desc->bcn_rsn_ie ?
> -                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
> -                           (priv->sec_info.wep_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa_enabled) ? "e" : "d",
> -                           (priv->sec_info.wpa2_enabled) ? "e" : "d",
> -                           priv->sec_info.encryption_mode, bss_desc->privacy);
> +               dbg_security_flags(ERROR, priv, bss_desc);
>                 return -1;
>         }

Significantly less info is printed in the second to last occurrence,
however that's probably not an issue. You should add an extra
parameter to your dbg_security_flags() function to capture this
difference.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
