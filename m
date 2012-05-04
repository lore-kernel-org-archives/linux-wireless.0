Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40682 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2EDS7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 14:59:55 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] Bluetooth: Fix coding style
Date: Fri,  4 May 2012 15:59:48 -0300
Message-Id: <1336157988-4602-1-git-send-email-gustavo@padovan.org> (sfid-20120504_210000_435747_C72E5D53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix offending styles all over the tree. This is in conformance David
Miller's style rules.

Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
---
 include/net/bluetooth/hci_core.h |    2 +-
 net/bluetooth/hci_event.c        |    2 +-
 net/bluetooth/l2cap_core.c       |   12 ++++++------
 net/bluetooth/l2cap_sock.c       |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ef6e654..6148352 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -433,7 +433,7 @@ static inline bool hci_conn_ssp_enabled(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
 	return (test_bit(HCI_SSP_ENABLED, &hdev->dev_flags) &&
-				test_bit(HCI_CONN_SSP_ENABLED, &conn->flags));
+		test_bit(HCI_CONN_SSP_ENABLED, &conn->flags));
 }
 
 static inline void hci_conn_hash_init(struct hci_dev *hdev)
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fb23c47..a094315 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1122,7 +1122,7 @@ static void hci_cc_le_set_scan_enable(struct hci_dev *hdev,
 		schedule_delayed_work(&hdev->adv_work, ADV_CLEAR_TIMEOUT);
 
 		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
-				hdev->discovery.state == DISCOVERY_FINDING) {
+		    hdev->discovery.state == DISCOVERY_FINDING) {
 			mgmt_interleaved_discovery(hdev);
 		} else {
 			hci_dev_lock(hdev);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9d6c650..89a50ed 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -426,7 +426,7 @@ void l2cap_chan_set_defaults(struct l2cap_chan *chan)
 static void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 {
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
-			__le16_to_cpu(chan->psm), chan->dcid);
+	       __le16_to_cpu(chan->psm), chan->dcid);
 
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
@@ -1128,7 +1128,7 @@ static struct l2cap_chan *l2cap_global_chan_by_scid(int state, u16 cid,
 			src_any = !bacmp(&bt_sk(sk)->src, BDADDR_ANY);
 			dst_any = !bacmp(&bt_sk(sk)->dst, BDADDR_ANY);
 			if ((src_match && dst_any) || (src_any && dst_match) ||
-							(src_any && dst_any))
+			    (src_any && dst_any))
 				c1 = c;
 		}
 	}
@@ -1385,7 +1385,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_any = !bacmp(&bt_sk(sk)->src, BDADDR_ANY);
 			dst_any = !bacmp(&bt_sk(sk)->dst, BDADDR_ANY);
 			if ((src_match && dst_any) || (src_any && dst_match) ||
-							(src_any && dst_any))
+			    (src_any && dst_any))
 				c1 = c;
 		}
 	}
@@ -1406,7 +1406,7 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid, bdaddr_t *d
 	int err;
 
 	BT_DBG("%s -> %s psm 0x%2.2x", batostr(src), batostr(dst),
-						__le16_to_cpu(chan->psm));
+	       __le16_to_cpu(chan->psm));
 
 	hdev = hci_get_route(dst, src);
 	if (!hdev)
@@ -3245,8 +3245,8 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 	flags  = __le16_to_cpu(rsp->flags);
 	result = __le16_to_cpu(rsp->result);
 
-	BT_DBG("scid 0x%4.4x flags 0x%2.2x result 0x%2.2x len %d",
-			scid, flags, result, len);
+	BT_DBG("scid 0x%4.4x flags 0x%2.2x result 0x%2.2x len %d", scid, flags,
+	       result, len);
 
 	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan)
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 4d03b45..8d8b50a 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -938,7 +938,7 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
 
 	skb = bt_skb_send_alloc(chan->sk, len, nb, &err);
 	if (!skb)
-		return (ERR_PTR(err));
+		return ERR_PTR(err);
 
 	return skb;
 }
-- 
1.7.10

