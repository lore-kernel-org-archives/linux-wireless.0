Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37294 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab0FKR1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 13:27:46 -0400
Date: Fri, 11 Jun 2010 10:27:33 -0700
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: Use a separate CCMP PN receive counter for
 management frames
Message-ID: <20100611172733.GA21347@jm.kir.nu>
References: <20100611024625.GB3985@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100611024625.GB3985@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When management frame protection (IEEE 802.11w) is used, we must use a
separate counter for tracking received CCMP packet number for the
management frames. The previously used NUM_RX_DATA_QUEUESth queue was
shared with data frames when QoS was not used and that can cause
problems in detecting replays incorrectly for robust management frames.
Add a new counter just for robust management frames to avoid this issue.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/debugfs_key.c |    2 +-
 net/mac80211/key.c         |    2 +-
 net/mac80211/key.h         |    8 +++++++-
 net/mac80211/rx.c          |    9 +++++++--
 net/mac80211/wpa.c         |    8 ++++++--
 5 files changed, 22 insertions(+), 7 deletions(-)

v2: Add a comment describing the use of CCMP receive counters per
    request from Johannes.


--- wireless-testing.orig/net/mac80211/debugfs_key.c	2010-06-11 10:22:06.000000000 -0700
+++ wireless-testing/net/mac80211/debugfs_key.c	2010-06-11 10:22:42.000000000 -0700
@@ -143,7 +143,7 @@ static ssize_t key_rx_spec_read(struct f
 		len = p - buf;
 		break;
 	case ALG_CCMP:
-		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
+		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
 			rpn = key->u.ccmp.rx_pn[i];
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%02x%02x%02x%02x%02x%02x\n",
--- wireless-testing.orig/net/mac80211/key.c	2010-06-11 10:22:06.000000000 -0700
+++ wireless-testing/net/mac80211/key.c	2010-06-11 10:22:42.000000000 -0700
@@ -273,7 +273,7 @@ struct ieee80211_key *ieee80211_key_allo
 		key->conf.iv_len = CCMP_HDR_LEN;
 		key->conf.icv_len = CCMP_MIC_LEN;
 		if (seq) {
-			for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+			for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++)
 				for (j = 0; j < CCMP_PN_LEN; j++)
 					key->u.ccmp.rx_pn[i][j] =
 						seq[CCMP_PN_LEN - j - 1];
--- wireless-testing.orig/net/mac80211/key.h	2010-06-11 10:22:06.000000000 -0700
+++ wireless-testing/net/mac80211/key.h	2010-06-11 10:23:04.000000000 -0700
@@ -77,7 +77,13 @@ struct ieee80211_key {
 		} tkip;
 		struct {
 			u8 tx_pn[6];
-			u8 rx_pn[NUM_RX_DATA_QUEUES][6];
+			/*
+			 * Last received packet number. The first
+			 * NUM_RX_DATA_QUEUES counters are used with Data
+			 * frames and the last counter is used with Robust
+			 * Management frames.
+			 */
+			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][6];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 			/* scratch buffers for virt_to_page() (crypto API) */
--- wireless-testing.orig/net/mac80211/rx.c	2010-06-11 10:22:06.000000000 -0700
+++ wireless-testing/net/mac80211/rx.c	2010-06-11 10:22:42.000000000 -0700
@@ -1268,11 +1268,13 @@ ieee80211_rx_h_defragment(struct ieee802
 						 rx->queue, &(rx->skb));
 		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
 		    ieee80211_has_protected(fc)) {
+			int queue = ieee80211_is_mgmt(fc) ?
+				NUM_RX_DATA_QUEUES : rx->queue;
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
 			entry->ccmp = 1;
 			memcpy(entry->last_pn,
-			       rx->key->u.ccmp.rx_pn[rx->queue],
+			       rx->key->u.ccmp.rx_pn[queue],
 			       CCMP_PN_LEN);
 		}
 		return RX_QUEUED;
@@ -1292,6 +1294,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	if (entry->ccmp) {
 		int i;
 		u8 pn[CCMP_PN_LEN], *rpn;
+		int queue;
 		if (!rx->key || rx->key->conf.alg != ALG_CCMP)
 			return RX_DROP_UNUSABLE;
 		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
@@ -1300,7 +1303,9 @@ ieee80211_rx_h_defragment(struct ieee802
 			if (pn[i])
 				break;
 		}
-		rpn = rx->key->u.ccmp.rx_pn[rx->queue];
+		queue = ieee80211_is_mgmt(fc) ?
+			NUM_RX_DATA_QUEUES : rx->queue;
+		rpn = rx->key->u.ccmp.rx_pn[queue];
 		if (memcmp(pn, rpn, CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
--- wireless-testing.orig/net/mac80211/wpa.c	2010-06-11 10:22:06.000000000 -0700
+++ wireless-testing/net/mac80211/wpa.c	2010-06-11 10:22:42.000000000 -0700
@@ -436,6 +436,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 pn[CCMP_PN_LEN];
 	int data_len;
+	int queue;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -453,7 +454,10 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[rx->queue], CCMP_PN_LEN) <= 0) {
+	queue = ieee80211_is_mgmt(hdr->frame_control) ?
+		NUM_RX_DATA_QUEUES : rx->queue;
+
+	if (memcmp(pn, key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) <= 0) {
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
@@ -470,7 +474,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 			return RX_DROP_UNUSABLE;
 	}
 
-	memcpy(key->u.ccmp.rx_pn[rx->queue], pn, CCMP_PN_LEN);
+	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
 	skb_trim(skb, skb->len - CCMP_MIC_LEN);


-- 
Jouni Malinen                                            PGP id EFC895FA
