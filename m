Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36258 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZKLUDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 15:03:25 -0500
Received: by bwz27 with SMTP id 27so2642997bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 12:03:29 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adam Wozniak <awozniak@irobot.com>
Subject: Re: compat-wireless and minstrel
Date: Thu, 12 Nov 2009 21:03:27 +0100
Cc: Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
References: <4AF0D54D.4090303@irobot.com> <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz> <4AFC655A.5020706@irobot.com>
In-Reply-To: <4AFC655A.5020706@irobot.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911122103.27455.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 20:43:22 Adam Wozniak wrote:
> I was hoping for more of an "ah-ha!" response. =)
> 
> It worked well initially, but when I let it run overnight it fell back 
> into that same failure mode.
>

great... :\

what about this patch?
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fbffce9..bde89f7 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -250,6 +250,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
+		/* make sure mandatory rates are always added */
+		supp_rates |= ieee80211_mandatory_rates(local, band);
+
 		rcu_read_lock();
 
 		sta = sta_info_get(local, mgmt->sa);
@@ -257,9 +260,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			u32 prev_rates;
 
 			prev_rates = sta->sta.supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->sta.supp_rates[band] = supp_rates |
-				ieee80211_mandatory_rates(local, band);
+			sta->sta.supp_rates[band] = supp_rates;
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			if (sta->sta.supp_rates[band] != prev_rates)
