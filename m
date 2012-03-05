Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab2CDX6y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:54 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 11/22] NFC: Set MIU and RW values from CONNECT and CC LLCP frames
Date: Mon,  5 Mar 2012 01:03:43 +0100
Message-Id: <1330905834-6994-12-git-send-email-sameo@linux.intel.com> (sfid-20120305_005857_161591_F1F3D41A)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use the maximum values for the LLCP Maximum Information Unit and Receive
Window Size.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   48 ++++++++++++++++++++++++++++++++++++++++++++--
 net/nfc/llcp/llcp.h     |    4 +++
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 8ebd322..a02292b 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -284,6 +284,9 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 	struct nfc_llcp_local *local;
 	struct sk_buff *skb;
 	u8 *service_name_tlv = NULL, service_name_tlv_length;
+	u8 *miux_tlv = NULL, miux_tlv_length;
+	u8 *rw_tlv = NULL, rw_tlv_length, rw;
+	__be16 miux;
 	int err;
 	u16 size = 0;
 
@@ -301,6 +304,14 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 		size += service_name_tlv_length;
 	}
 
+	miux = cpu_to_be16(LLCP_MAX_MIUX);
+	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0, &miux_tlv_length);
+	size += miux_tlv_length;
+
+	rw = LLCP_MAX_RW;
+	rw_tlv = nfc_llcp_build_tlv(LLCP_TLV_RW, &rw, 0, &rw_tlv_length);
+	size += rw_tlv_length;
+
 	pr_debug("SKB size %d SN length %zu\n", size, sock->service_name_len);
 
 	skb = llcp_allocate_pdu(sock, LLCP_PDU_CONNECT, size);
@@ -313,6 +324,9 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 		skb = llcp_add_tlv(skb, service_name_tlv,
 					service_name_tlv_length);
 
+	skb = llcp_add_tlv(skb, miux_tlv, miux_tlv_length);
+	skb = llcp_add_tlv(skb, rw_tlv, rw_tlv_length);
+
 	skb_queue_tail(&local->tx_queue, skb);
 
 	return 0;
@@ -321,6 +335,8 @@ error_tlv:
 	pr_err("error %d\n", err);
 
 	kfree(service_name_tlv);
+	kfree(miux_tlv);
+	kfree(rw_tlv);
 
 	return err;
 }
@@ -329,6 +345,11 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
 {
 	struct nfc_llcp_local *local;
 	struct sk_buff *skb;
+	u8 *miux_tlv = NULL, miux_tlv_length;
+	u8 *rw_tlv = NULL, rw_tlv_length, rw;
+	__be16 miux;
+	int err;
+	u16 size = 0;
 
 	pr_debug("Sending CC\n");
 
@@ -336,13 +357,34 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
 	if (local == NULL)
 		return -ENODEV;
 
-	skb = llcp_allocate_pdu(sock, LLCP_PDU_CC, 0);
-	if (skb == NULL)
-		return -ENOMEM;
+	miux = cpu_to_be16(LLCP_MAX_MIUX);
+	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0, &miux_tlv_length);
+	size += miux_tlv_length;
+
+	rw = LLCP_MAX_RW;
+	rw_tlv = nfc_llcp_build_tlv(LLCP_TLV_RW, &rw, 0, &rw_tlv_length);
+	size += rw_tlv_length;
+
+	skb = llcp_allocate_pdu(sock, LLCP_PDU_CC, size);
+	if (skb == NULL) {
+		err = -ENOMEM;
+		goto error_tlv;
+	}
+
+	skb = llcp_add_tlv(skb, miux_tlv, miux_tlv_length);
+	skb = llcp_add_tlv(skb, rw_tlv, rw_tlv_length);
 
 	skb_queue_tail(&local->tx_queue, skb);
 
 	return 0;
+
+error_tlv:
+	pr_err("error %d\n", err);
+
+	kfree(miux_tlv);
+	kfree(rw_tlv);
+
+	return err;
 }
 
 int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason)
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 054c64f..70e1762 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -28,6 +28,10 @@ enum llcp_state {
 #define LLCP_DEFAULT_RW  1
 #define LLCP_DEFAULT_MIU 128
 
+#define LLCP_MAX_LTO  0xff
+#define LLCP_MAX_RW   15
+#define LLCP_MAX_MIUX 0x7ff
+
 #define LLCP_WKS_NUM_SAP   16
 #define LLCP_SDP_NUM_SAP   16
 #define LLCP_LOCAL_NUM_SAP 32
-- 
1.7.7.3

