Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQNel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:41 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 01/21] wil6210: Helpers to deal with 'cidxtid' fields
Date: Mon, 17 Mar 2014 15:34:05 +0200
Message-ID: <1395063265-6522-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143453_754422_A42B56F0)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Encode/decode helpers

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 092081e..7afaa5e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -588,7 +588,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
-			.cidxtid = (cid & 0xf) | ((tid & 0xf) << 4),
+			.cidxtid = mk_cidxtid(cid, tid),
 			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
 			.mac_ctrl = 0,
 			.to_resolution = 0,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 980dccc..273d00f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -125,6 +125,31 @@ struct RGF_ICR {
 
 /* Hardware definitions end */
 
+/**
+ * mk_cidxtid - construct @cidxtid field
+ * @cid: CID value
+ * @tid: TID value
+ *
+ * @cidxtid field encoded as bits 0..3 - CID; 4..7 - TID
+ */
+static inline u8 mk_cidxtid(u8 cid, u8 tid)
+{
+	return ((tid & 0xf) << 4) | (cid & 0xf);
+}
+
+/**
+ * parse_cidxtid - parse @cidxtid field
+ * @cid: store CID value here
+ * @tid: store TID value here
+ *
+ * @cidxtid field encoded as bits 0..3 - CID; 4..7 - TID
+ */
+static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
+{
+	*cid = cidxtid & 0xf;
+	*tid = (cidxtid >> 4) & 0xf;
+}
+
 struct wil6210_mbox_ring {
 	u32 base;
 	u16 entry_size; /* max. size of mbox entry, incl. all headers */
-- 
1.8.3.2

