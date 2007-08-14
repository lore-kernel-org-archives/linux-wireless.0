Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509AbXHNLwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:52:39 -0400
Subject: [PATCH] hostapd: also get outgoing EAPOL frames from monitor iface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Andy Green <andy@warmcat.com>
In-Reply-To: <1187046852.32435.36.camel@johannes.berg>
References: <1186992004.27916.53.camel@johannes.berg>
	 <1187046852.32435.36.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 12:53:07 +0200
Message-Id: <1187088787.4069.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd doesn't really seem to care much at the moment, but it really
should be notified about EAPOL frame transmit callbacks as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-14 11:49:58.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 12:44:05.000000000 +0200
@@ -1518,6 +1518,54 @@ struct sock_filter msock_filter_insns[] 
 
 	/* do we need any other frames? */
 
+	/*
+	 * do the rest of the test only on frames we sent ourselves
+	 */
+	BPF_STMT(BPF_LD   | BPF_W | BPF_ABS, 4),
+	BPF_STMT(BPF_ALU  | BPF_AND | BPF_K,
+		 LE32(1<<IEEE80211_RADIOTAP_TX_FLAGS)),
+	BPF_JUMP(BPF_JMP  | BPF_JEQ, 0, FAIL, 0),
+
+	/*
+	 * drop non-data frames, WDS frames
+	 */
+	/* load the lower byte of the frame control field */
+	BPF_STMT(BPF_LD   | BPF_B | BPF_IND, 0),
+	/* mask off QoS bit */
+	BPF_STMT(BPF_ALU  | BPF_AND | BPF_K, 0x0c),
+	/* drop non-data frames */
+	BPF_JUMP(BPF_JMP  | BPF_JEQ, 8, 0, FAIL),
+	/* load the upper byte of the frame control field */
+	BPF_STMT(BPF_LD   | BPF_B | BPF_IND, 0),
+	/* mask off toDS/fromDS */
+	BPF_STMT(BPF_ALU  | BPF_AND | BPF_K, 0x03),
+	/* drop WDS frames */
+	BPF_JUMP(BPF_JMP  | BPF_JEQ, 3, FAIL, 0),
+
+	/*
+	 * add header length to index
+	 */
+	/* load the lower byte of the frame control field */
+	BPF_STMT(BPF_LD   | BPF_B | BPF_IND, 0),
+	/* mask off QoS bit */
+	BPF_STMT(BPF_ALU  | BPF_AND | BPF_K, 0x80),
+	/* right shift it by 6 to give 0 or 2 */
+	BPF_STMT(BPF_ALU  | BPF_RSH | BPF_K, 6),
+	/* add data frame header length */
+	BPF_STMT(BPF_ALU  | BPF_ADD | BPF_K, 24),
+	/* add index, was start of 802.11 header */
+	BPF_STMT(BPF_ALU  | BPF_ADD | BPF_X, 0),
+	/* move to index, now start of LL header */
+	BPF_STMT(BPF_MISC | BPF_TAX, 0),
+
+	/*
+	 * Accept EAPOL frames
+	 */
+	BPF_STMT(BPF_LD  | BPF_W | BPF_IND, 0),
+	BPF_JUMP(BPF_JMP | BPF_JEQ, 0xAAAA0300, 0, FAIL),
+	BPF_STMT(BPF_LD  | BPF_W | BPF_IND, 4),
+	BPF_JUMP(BPF_JMP | BPF_JEQ, 0x0000888E, PASS, FAIL),
+
 	/* keep these last two statements or change the code below */
 	/* return 0 == "DROP" */
 	BPF_STMT(BPF_RET | BPF_K, 0),


