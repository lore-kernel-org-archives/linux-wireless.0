Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:55269 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161039AbXDTFU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 01:20:27 -0400
Date: Fri, 20 Apr 2007 00:19:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Sort supported rates in scan output
Message-ID: <46284d71.8kVOR3LhjxSoo7lb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mac80211, the results of a scan show basic rates followed by extended
rates, thus values are not listed in any particular order. This patch sorts
all rates in increasing value.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c
+++ wireless-dev/net/mac80211/ieee80211_sta.c
@@ -3013,7 +3017,8 @@ ieee80211_sta_scan_result(struct net_dev
 	if (bss && bss->supp_rates_len > 0) {
 		/* display all supported rates in readable format */
 		char *p = current_ev + IW_EV_LCP_LEN;
-		int i;
+		int i, j, tmp;
+		int trial_rate, cur_rate = 0;
 
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = SIOCGIWRATE;
@@ -3021,8 +3026,14 @@ ieee80211_sta_scan_result(struct net_dev
 		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
 
 		for (i = 0; i < bss->supp_rates_len; i++) {
-			iwe.u.bitrate.value = ((bss->supp_rates[i] &
-							0x7f) * 500000);
+			trial_rate = 99999999;
+			for (j = 0; j < bss->supp_rates_len; j++) {
+				tmp = bss->supp_rates[j] & 0x7f;
+				if (tmp > cur_rate && tmp < trial_rate)
+					trial_rate = tmp;
+			}
+			cur_rate = trial_rate;
+			iwe.u.bitrate.value = cur_rate * 500000;
 			p = iwe_stream_add_value(current_ev, p,
 					end_buf, &iwe, IW_EV_PARAM_LEN);
 		}
