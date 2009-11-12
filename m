Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34769 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZKLXfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 18:35:52 -0500
Received: by bwz27 with SMTP id 27so2850952bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 15:35:56 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adam Wozniak <awozniak@irobot.com>
Subject: Re: compat-wireless and minstrel
Date: Fri, 13 Nov 2009 00:35:52 +0100
Cc: Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
References: <4AF0D54D.4090303@irobot.com> <200911122103.27455.chunkeey@googlemail.com> <4AFC8E4F.5090307@irobot.com>
In-Reply-To: <4AFC8E4F.5090307@irobot.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911130035.52308.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 23:38:07 Adam Wozniak wrote:
> I see what you're doing there.
> That didn't quite work, but I'm fairly confident this one will.
yep, what about the attached version? ...it's slightly different...

BTW: Use "diff -up" or "diff -uprN" to create patches. (or git :) )
---

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fbffce9..7c6c170 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -246,9 +246,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
+	/* make sure mandatory rates are always added */
+	supp_rates = ieee80211_mandatory_rates(local, band);
+
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+		supp_rates |= ieee80211_sta_get_rates(local, elems, band);
 
 		rcu_read_lock();
 
@@ -257,9 +260,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			u32 prev_rates;
 
 			prev_rates = sta->sta.supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->sta.supp_rates[band] = supp_rates |
-				ieee80211_mandatory_rates(local, band);
+			sta->sta.supp_rates[band] = supp_rates;
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			if (sta->sta.supp_rates[band] != prev_rates)
@@ -272,6 +273,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				    (unsigned long long) supp_rates,
 				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
+			rate_control_rate_init(sta);
 		} else
 			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
 
