Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44728 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1BHLLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 06:11:10 -0500
Received: by wwa36 with SMTP id 36so5886734wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 03:11:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
Date: Tue, 8 Feb 2011 16:41:06 +0530
Message-ID: <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 1, 2011 at 6:19 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> At least the WMM spec says we should reply to
> unicast probe request frames that go to us.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ibss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/ibss.c   2011-02-01 12:58:16.000000000 +0100
> +++ wireless-testing/net/mac80211/ibss.c        2011-02-01 13:47:44.000000000 +0100
> @@ -689,7 +689,7 @@ static void ieee80211_rx_mgmt_probe_req(
>               mgmt->bssid, tx_last_beacon);
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>
> -       if (!tx_last_beacon)
> +       if (!tx_last_beacon && !(status->rx_flags & IEEE80211_RX_RA_MATCH))
>                return;
>
>        if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&

Hi Johannes,
             tested with the same thing (in addition of passing the
rx_status structure) and it is working fine.

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 775fb63..d26bd22 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -665,7 +665,8 @@ static void ieee80211_sta_find_ibss(struct
ieee80211_sub_if_data *sdata)

 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
                                        struct ieee80211_mgmt *mgmt,
-                                       size_t len)
+                                       size_t len,
+                                       struct ieee80211_rx_status *rx_status)
 {
        struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
        struct ieee80211_local *local = sdata->local;
@@ -689,7 +690,7 @@ static void ieee80211_rx_mgmt_probe_req(struct
ieee80211_sub_if_data *sdata,
               mgmt->bssid, tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */

-       if (!tx_last_beacon)
+       if (!tx_last_beacon && !(rx_status->rx_flags & IEEE80211_RX_RA_MATCH))
                return;

        if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
@@ -786,7 +787,8 @@ void ieee80211_ibss_rx_queued_mgmt(struct
ieee80211_sub_if_data *sdata,

        switch (fc & IEEE80211_FCTL_STYPE) {
        case IEEE80211_STYPE_PROBE_REQ:
-               ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len);
+               ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len,
+                                            rx_status);
                break;
        case IEEE80211_STYPE_PROBE_RESP:
                ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
~

thanks,
shafi

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
