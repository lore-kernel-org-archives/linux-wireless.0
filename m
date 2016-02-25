Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34115 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbcBYA6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:58:48 -0500
Received: by mail-ig0-f169.google.com with SMTP id g6so3547914igt.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:58:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-2-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-2-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 11:58:28 +1100
Message-ID: <CAGRGNgW9TPc4ixGLSU1hzaG_5U951KX9NetD-0HSkTqpGpBh4g@mail.gmail.com> (sfid-20160225_015852_642257_46FBC6FF)
Subject: Re: [PATCH 1/7] mwifiex: scan: simplify dereference of bss_desc fields
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> given this structure:
> struct foo {
>   struct bar {
>      int baz;
>   }
> }
>
> these accesses are equivalent:
> (*(foo->bar)).baz
> foo->bar->baz
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

You leave a lot of unnecessary parenthesis in the conditions, i.e.

if (ie && (ie->iee_hdr.element_id == WLAN_EID_RSN))

is equivalent to

if (ie && ie->iee_hdr.element_id == WLAN_EID_RSN)

however I think you remove most of these in subsequent patches.

Other than that, it's a good cleanup.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 96 ++++++++++++++---------------
>  1 file changed, 45 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index c20017c..43d7a92 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -121,8 +121,8 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
>         struct ie_body *iebody;
>         u8 ret = MWIFIEX_OUI_NOT_PRESENT;
>
> -       if (((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).
> -                                       ieee_hdr.element_id == WLAN_EID_RSN))) {
> +       if (bss_desc->bcn_rsn_ie &&
> +           (bss_desc->bcn_rsn_ie->ieee_hdr.element_id == WLAN_EID_RSN)) {
>                 iebody = (struct ie_body *)
>                          (((u8 *) bss_desc->bcn_rsn_ie->data) +
>                           RSN_GTK_OUI_OFFSET);
> @@ -148,9 +148,9 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
>         struct ie_body *iebody;
>         u8 ret = MWIFIEX_OUI_NOT_PRESENT;
>
> -       if (((bss_desc->bcn_wpa_ie) &&
> -            ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
> -             WLAN_EID_VENDOR_SPECIFIC))) {
> +       if (bss_desc->bcn_wpa_ie &&
> +           (bss_desc->bcn_wpa_ie->vend_hdr.element_id ==
> +            WLAN_EID_VENDOR_SPECIFIC)) {
>                 iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
>                 oui = &mwifiex_wpa_oui[cipher][0];
>                 ret = mwifiex_search_oui_in_ie(iebody, oui);
> @@ -181,8 +181,8 @@ mwifiex_is_bss_wapi(struct mwifiex_private *priv,
>  {
>         if (priv->sec_info.wapi_enabled &&
>             (bss_desc->bcn_wapi_ie &&
> -            ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
> -                       WLAN_EID_BSS_AC_ACCESS_DELAY))) {
> +            (bss_desc->bcn_wapi_ie->ieee_hdr.element_id ==
> +             WLAN_EID_BSS_AC_ACCESS_DELAY))) {
>                 return true;
>         }
>         return false;
> @@ -197,12 +197,12 @@ mwifiex_is_bss_no_sec(struct mwifiex_private *priv,
>                       struct mwifiex_bssdescriptor *bss_desc)
>  {
>         if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
> -           !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
> -               ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
> +           !priv->sec_info.wpa2_enabled &&
> +           (!bss_desc->bcn_wpa_ie ||
> +               (bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
>                  WLAN_EID_VENDOR_SPECIFIC)) &&
> -           ((!bss_desc->bcn_rsn_ie) ||
> -               ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
> -                WLAN_EID_RSN)) &&
> +           (!bss_desc->bcn_rsn_ie ||
> +               (bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
>             !priv->sec_info.encryption_mode && !bss_desc->privacy) {
>                 return true;
>         }
> @@ -233,9 +233,10 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
>                    struct mwifiex_bssdescriptor *bss_desc)
>  {
>         if (!priv->sec_info.wep_enabled && priv->sec_info.wpa_enabled &&
> -           !priv->sec_info.wpa2_enabled && ((bss_desc->bcn_wpa_ie) &&
> -           ((*(bss_desc->bcn_wpa_ie)).
> -            vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC))
> +           !priv->sec_info.wpa2_enabled &&
> +           (bss_desc->bcn_wpa_ie &&
> +            (bss_desc->bcn_wpa_ie->vend_hdr.element_id ==
> +             WLAN_EID_VENDOR_SPECIFIC))
>            /*
>             * Privacy bit may NOT be set in some APs like
>             * LinkSys WRT54G && bss_desc->privacy
> @@ -245,12 +246,10 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
>                             "info: %s: WPA:\t"
>                             "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
>                             "EncMode=%#x privacy=%#x\n", __func__,
> -                           (bss_desc->bcn_wpa_ie) ?
> -                           (*bss_desc->bcn_wpa_ie).
> -                           vend_hdr.element_id : 0,
> -                           (bss_desc->bcn_rsn_ie) ?
> -                           (*bss_desc->bcn_rsn_ie).
> -                           ieee_hdr.element_id : 0,
> +                           bss_desc->bcn_wpa_ie ?
> +                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> +                           bss_desc->bcn_rsn_ie ?
> +                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
>                             (priv->sec_info.wep_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa2_enabled) ? "e" : "d",
> @@ -269,11 +268,10 @@ static bool
>  mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
>                     struct mwifiex_bssdescriptor *bss_desc)
>  {
> -       if (!priv->sec_info.wep_enabled &&
> -           !priv->sec_info.wpa_enabled &&
> +       if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
>             priv->sec_info.wpa2_enabled &&
> -           ((bss_desc->bcn_rsn_ie) &&
> -            ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id == WLAN_EID_RSN))) {
> +           (bss_desc->bcn_rsn_ie &&
> +            (bss_desc->bcn_rsn_ie->ieee_hdr.element_id == WLAN_EID_RSN))) {
>                 /*
>                  * Privacy bit may NOT be set in some APs like
>                  * LinkSys WRT54G && bss_desc->privacy
> @@ -282,12 +280,10 @@ mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
>                             "info: %s: WPA2:\t"
>                             "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
>                             "EncMode=%#x privacy=%#x\n", __func__,
> -                           (bss_desc->bcn_wpa_ie) ?
> -                           (*bss_desc->bcn_wpa_ie).
> -                           vend_hdr.element_id : 0,
> -                           (bss_desc->bcn_rsn_ie) ?
> -                           (*bss_desc->bcn_rsn_ie).
> -                           ieee_hdr.element_id : 0,
> +                           bss_desc->bcn_wpa_ie ?
> +                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> +                           bss_desc->bcn_rsn_ie ?
> +                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
>                             (priv->sec_info.wep_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa2_enabled) ? "e" : "d",
> @@ -308,11 +304,11 @@ mwifiex_is_bss_adhoc_aes(struct mwifiex_private *priv,
>  {
>         if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
>             !priv->sec_info.wpa2_enabled &&
> -           ((!bss_desc->bcn_wpa_ie) ||
> -            ((*(bss_desc->bcn_wpa_ie)).
> -             vend_hdr.element_id != WLAN_EID_VENDOR_SPECIFIC)) &&
> -           ((!bss_desc->bcn_rsn_ie) ||
> -            ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
> +           (!bss_desc->bcn_wpa_ie ||
> +            (bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
> +             WLAN_EID_VENDOR_SPECIFIC)) &&
> +           (!bss_desc->bcn_rsn_ie ||
> +            (bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
>             !priv->sec_info.encryption_mode && bss_desc->privacy) {
>                 return true;
>         }
> @@ -329,23 +325,21 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
>  {
>         if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
>             !priv->sec_info.wpa2_enabled &&
> -           ((!bss_desc->bcn_wpa_ie) ||
> -            ((*(bss_desc->bcn_wpa_ie)).
> -             vend_hdr.element_id != WLAN_EID_VENDOR_SPECIFIC)) &&
> -           ((!bss_desc->bcn_rsn_ie) ||
> -            ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
> +           (!bss_desc->bcn_wpa_ie ||
> +            (bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
> +             WLAN_EID_VENDOR_SPECIFIC)) &&
> +           (!bss_desc->bcn_rsn_ie ||
> +            (bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
>             priv->sec_info.encryption_mode && bss_desc->privacy) {
>                 mwifiex_dbg(priv->adapter, INFO,
>                             "info: %s: dynamic\t"
>                             "WEP: wpa_ie=%#x wpa2_ie=%#x\t"
>                             "EncMode=%#x privacy=%#x\n",
>                             __func__,
> -                           (bss_desc->bcn_wpa_ie) ?
> -                           (*bss_desc->bcn_wpa_ie).
> -                           vend_hdr.element_id : 0,
> -                           (bss_desc->bcn_rsn_ie) ?
> -                           (*bss_desc->bcn_rsn_ie).
> -                           ieee_hdr.element_id : 0,
> +                           bss_desc->bcn_wpa_ie ?
> +                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> +                           bss_desc->bcn_rsn_ie ?
> +                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
>                             priv->sec_info.encryption_mode,
>                             bss_desc->privacy);
>                 return true;
> @@ -464,10 +458,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
>                             "info: %s: failed: wpa_ie=%#x wpa2_ie=%#x WEP=%s\t"
>                             "WPA=%s WPA2=%s EncMode=%#x privacy=%#x\n",
>                             __func__,
> -                           (bss_desc->bcn_wpa_ie) ?
> -                           (*bss_desc->bcn_wpa_ie).vend_hdr.element_id : 0,
> -                           (bss_desc->bcn_rsn_ie) ?
> -                           (*bss_desc->bcn_rsn_ie).ieee_hdr.element_id : 0,
> +                           bss_desc->bcn_wpa_ie ?
> +                           bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
> +                           bss_desc->bcn_rsn_ie ?
> +                           bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
>                             (priv->sec_info.wep_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa_enabled) ? "e" : "d",
>                             (priv->sec_info.wpa2_enabled) ? "e" : "d",
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
