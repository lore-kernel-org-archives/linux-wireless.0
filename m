Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55227 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbZCRMHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 08:07:39 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v4] mac80211: don't drop nullfunc frames during software scan
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2009 14:06:44 +0200
Message-ID: <20090318120644.19664.28373.stgit@tikku> (sfid-20090318_130742_685080_65422811)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_h_check_assoc() was dropping everything else than probe
requests during software scan. So the nullfunc frame with the power save
bit was dropped and AP never received it. This meant that AP never
buffered any frames for the station during software scan.

Fix this by allowing to transmit both probe request and nullfunc frames
during software scan. Tested with stlc45xx.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/scan.c |   13 +++++++++++++
 net/mac80211/tx.c   |   14 +++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5030a3c..46f35dc 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -409,6 +409,19 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 		return 0;
 	}
 
+	/*
+	 * Hardware/driver doesn't support hw_scan, so use software
+	 * scanning instead. First send a nullfunc frame with power save
+	 * bit on so that AP will buffer the frames for us while we are not
+	 * listening, then send probe requests to each channel and wait for
+	 * the responses. After all channels are scanned, tune back to the
+	 * original channel and send a nullfunc frame with power save bit
+	 * off to trigger the AP to send us all the buffered frames.
+	 *
+	 * Note that while local->sw_scanning is true everything else but
+	 * nullfunc frames and probe requests will be dropped in
+	 * ieee80211_tx_h_check_assoc().
+	 */
 	local->sw_scanning = true;
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(local_to_hw(local));
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 457238a..af768fc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -193,7 +193,19 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sw_scanning) &&
-	    !ieee80211_is_probe_req(hdr->frame_control))
+	    !ieee80211_is_probe_req(hdr->frame_control) &&
+	    !ieee80211_is_nullfunc(hdr->frame_control))
+		/*
+		 * When software scanning only nullfunc frames (to notify
+		 * the sleep state to the AP) and probe requests (for the
+		 * active scan) are allowed, all other frames should not be
+		 * sent and we should not get here, but if we do
+		 * nonetheless, drop them to avoid sending them
+		 * off-channel. See the link below and
+		 * ieee80211_start_scan() for more.
+		 *
+		 * http://article.gmane.org/gmane.linux.kernel.wireless.general/30089
+		 */
 		return TX_DROP;
 
 	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)

