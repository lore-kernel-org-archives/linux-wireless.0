Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZGJPZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 11:25:45 -0400
Subject: [PATCH/RFC] mac80211_hwsim: report fixed signal strength
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <Jouni.Malinen@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 16:56:59 +0200
Message-Id: <1247237819.29747.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason to think that hwsim has any
actual signal strength, but for testing it is
very useful to have it report _some_ value to
the stack so I can see if the value ends up
being reported correctly

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Anyone have any objections? I'm not sure -- but it's still useful at
least for me testing the upper layers.

 drivers/net/wireless/mac80211_hwsim.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-10 16:26:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-10 16:27:51.000000000 +0200
@@ -406,7 +406,8 @@ static bool mac80211_hwsim_tx_frame(stru
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
-	/* TODO: simulate signal strength (and optional packet drop) */
+	/* TODO: simulate real signal strength (and optional packet loss) */
+	rx_status.signal = -50;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1026,7 +1027,8 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 
-		hw->flags = IEEE80211_HW_MFP_CAPABLE;
+		hw->flags = IEEE80211_HW_MFP_CAPABLE |
+			    IEEE80211_HW_SIGNAL_DBM;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);


