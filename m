Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbbIAOzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 10:55:10 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v2 2/9] nfc: nci: Add function to get max packet size for conn
Date: Tue,  1 Sep 2015 17:54:21 +0300
Message-Id: <1441119268-30654-3-git-send-email-robert.dolca@intel.com> (sfid-20150901_165937_756663_65F60D41)
In-Reply-To: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
References: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FDP driver needs to send the firmware as regular packets
(not fragmented). The driver should have a way to
get the max packet size for a given connection.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/data.c         | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index d0d0f1e..8a4ab1e 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -351,6 +351,7 @@ int nci_prop_ntf_packet(struct nci_dev *ndev, __u16 opcode,
 void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb);
 int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload);
 int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb);
+__u8 nci_conn_max_data_pkt_payload_size(struct nci_dev *ndev, __u8 conn_id);
 void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 				__u8 conn_id, int err);
 void nci_hci_data_received_cb(void *context, struct sk_buff *skb, int err);
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 83acd18..30cbed7 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -90,6 +90,18 @@ static inline void nci_push_data_hdr(struct nci_dev *ndev,
 	nci_pbf_set((__u8 *)hdr, pbf);
 }
 
+__u8 nci_conn_max_data_pkt_payload_size(struct nci_dev *ndev, __u8 conn_id)
+{
+	struct nci_conn_info *conn_info;
+
+	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
+	if (!conn_info)
+		return -EPROTO;
+
+	return conn_info->max_pkt_payload_len;
+}
+EXPORT_SYMBOL(nci_conn_max_data_pkt_payload_size);
+
 static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 				   __u8 conn_id,
 				   struct sk_buff *skb) {
-- 
1.9.1

