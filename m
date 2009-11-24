Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:38260 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933672AbZKXRFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:05:32 -0500
Subject: [PATCH v2 2/2] mac80211: minstrel try all rates
From: Adam Wozniak <awozniak@irobot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0B2F6E.7050907@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:05:31 -0800
Message-ID: <1259082331.2573.19.camel@awozniak-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In Ad-Hoc mode, it is possible for minstrel to be initialized without complete rate information.
In these cases, throughput suffers because not all rates are tried.  This patch tells minstrel to try all rates.  
This won't cause problems, because unsupported rates will simply fail, causing minstrel to set their probability to 0%.
(Hopefully not whitespace damaged this time)

Signed-off-by: Adam Wozniak <awozniak@irobot.com>
---
diff --git a/net/mac80211/rc80211_minstrel.c
b/net/mac80211/rc80211_minstrel.c
index 6e5d68b..3a8fe30 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -395,8 +395,6 @@ minstrel_rate_init(void *priv, struct
ieee80211_supported_band *sband,
 		unsigned int tx_time_single;
 		unsigned int cw = mp->cw_min;
 
-		if (!rate_supported(sta, sband->band, i))
-			continue;
 		n++;
 		memset(mr, 0, sizeof(*mr));
 

