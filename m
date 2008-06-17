Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56175 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYFQP7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 11:59:39 -0400
Message-Id: <20080617155844.056034562@localhost> (sfid-20080617_180029_803622_6A7BBB2B)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 2/7] 802.11w: CCMP for management frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend CCMP to support encryption and decryption of unicast management
frames.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/net/mac80211/wpa.c
===================================================================
--- wireless-testing.orig/net/mac80211/wpa.c
+++ wireless-testing/net/mac80211/wpa.c
@@ -299,7 +299,7 @@ static void ccmp_special_blocks(struct s
 				int encrypted)
 {
 	u16 fc;
-	int a4_included, qos_included;
+	int a4_included, qos_included, mgmt;
 	u8 qos_tid, *fc_pos, *data, *sa, *da;
 	int len_a;
 	size_t data_len;
@@ -309,6 +309,7 @@ static void ccmp_special_blocks(struct s
 	fc = fc_pos[0] ^ (fc_pos[1] << 8);
 	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
 		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
+	mgmt = (fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT;
 
 	ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len);
 	data_len -= CCMP_HDR_LEN + (encrypted ? CCMP_MIC_LEN : 0);
@@ -320,8 +321,10 @@ static void ccmp_special_blocks(struct s
 	/* First block, b_0 */
 
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
-	/* Nonce: QoS Priority | A2 | PN */
-	b_0[1] = qos_tid;
+	/* Nonce: Nonce Flags | A2 | PN
+	 * Nonce Flags: Priority (b0..b3) | Management (b4) | Reserved (b5..b7)
+	 */
+	b_0[1] = qos_tid | (mgmt << 4);
 	memcpy(&b_0[2], hdr->addr2, 6);
 	memcpy(&b_0[8], pn, CCMP_PN_LEN);
 	/* l(m) */
@@ -338,8 +341,11 @@ static void ccmp_special_blocks(struct s
 
 	aad[0] = 0; /* (len_a >> 8) & 0xff; */
 	aad[1] = len_a & 0xff;
-	/* Mask FC: zero subtype b4 b5 b6 */
-	aad[2] = fc_pos[0] & ~(BIT(4) | BIT(5) | BIT(6));
+	aad[2] = fc_pos[0]; /* FC type/subtype */
+	if (!mgmt) {
+		/* Mask FC: zero subtype b4 b5 b6 */
+		aad[2] &= BIT(4) | BIT(5) | BIT(6);
+	}
 	/* Retry, PwrMgt, MoreData; set Protected */
 	aad[3] = (fc_pos[1] & ~(BIT(3) | BIT(4) | BIT(5))) | BIT(6);
 	memcpy(&aad[4], &hdr->addr1, 18);
Index: wireless-testing/net/mac80211/tx.c
===================================================================
--- wireless-testing.orig/net/mac80211/tx.c
+++ wireless-testing/net/mac80211/tx.c
@@ -446,6 +446,26 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
+static int ieee80211_use_mfp(u16 fc, struct sta_info *sta, struct sk_buff *skb)
+{
+	u16 stype;
+
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+		return 0;
+
+	if (sta == NULL || !test_sta_flags(sta, WLAN_STA_MFP))
+		return 0;
+
+	stype = fc & IEEE80211_FCTL_STYPE;
+	if (stype != IEEE80211_STYPE_DEAUTH &&
+	    stype != IEEE80211_STYPE_DISASSOC &&
+	    stype != IEEE80211_STYPE_ACTION)
+		return 0;
+
+	return 1;
+}
+
+
 static ieee80211_tx_result
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -482,10 +502,14 @@ ieee80211_tx_h_select_key(struct ieee802
 			    stype == IEEE80211_STYPE_AUTH)
 				break;
 		case ALG_TKIP:
-		case ALG_CCMP:
 			if (!WLAN_FC_DATA_PRESENT(fc))
 				tx->key = NULL;
 			break;
+		case ALG_CCMP:
+			if (!WLAN_FC_DATA_PRESENT(fc) &&
+			    !ieee80211_use_mfp(fc, tx->sta, tx->skb))
+				tx->key = NULL;
+			break;
 		}
 	}
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
