Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38658 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030279AbeFSSpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 14:45:08 -0400
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Thibaut Robert <thibaut.robert@gmail.com>
Subject: [PATCH v2] staging: wilc1000: Use common structs to parse ip packets
Date: Tue, 19 Jun 2018 20:44:19 +0200
Message-Id: <20180619184419.10304-1-thibaut.robert@gmail.com> (sfid-20180619_204523_335248_53A79E6B)
In-Reply-To: <20180604105549.04031722@ajaysk-VirtualBox>
References: <20180604105549.04031722@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use structs ethhdr, iphdr and tcphdr instead of manual parsing in
tcp_process.
This commit fix handling of ip packets containing options.
It also fixes the following sparse warning:

drivers/staging/wilc1000//wilc_wlan.c:201:19: warning: cast to restricted __be16

Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 43 ++++++++++------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 55755d7fbb30..85af36595e69 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/if_ether.h>
+#include <linux/ip.h>
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
@@ -150,9 +152,8 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 
 static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 {
-	u8 *eth_hdr_ptr;
-	u8 *buffer = tqe->buffer;
-	unsigned short h_proto;
+	void *buffer = tqe->buffer;
+	const struct ethhdr *eth_hdr_ptr = buffer;
 	int i;
 	unsigned long flags;
 	struct wilc_vif *vif;
@@ -163,37 +164,23 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	eth_hdr_ptr = &buffer[0];
-	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
-	if (h_proto == ETH_P_IP) {
-		u8 *ip_hdr_ptr;
-		u8 protocol;
+	if (eth_hdr_ptr->h_proto == htons(ETH_P_IP)) {
+		const struct iphdr *ip_hdr_ptr = buffer + ETH_HLEN;
 
-		ip_hdr_ptr = &buffer[ETHERNET_HDR_LEN];
-		protocol = ip_hdr_ptr[9];
-
-		if (protocol == 0x06) {
-			u8 *tcp_hdr_ptr;
+		if (ip_hdr_ptr->protocol == IPPROTO_TCP) {
+			const struct tcphdr *tcp_hdr_ptr;
 			u32 IHL, total_length, data_offset;
 
-			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
-			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
-			total_length = ((u32)ip_hdr_ptr[2] << 8) +
-					(u32)ip_hdr_ptr[3];
-			data_offset = ((u32)tcp_hdr_ptr[12] & 0xf0) >> 2;
+			IHL = ip_hdr_ptr->ihl << 2;
+			tcp_hdr_ptr = buffer + ETH_HLEN + IHL;
+			total_length = ntohs(ip_hdr_ptr->tot_len);
+
+			data_offset = tcp_hdr_ptr->doff << 2;
 			if (total_length == (IHL + data_offset)) {
 				u32 seq_no, ack_no;
 
-				seq_no = ((u32)tcp_hdr_ptr[4] << 24) +
-					 ((u32)tcp_hdr_ptr[5] << 16) +
-					 ((u32)tcp_hdr_ptr[6] << 8) +
-					 (u32)tcp_hdr_ptr[7];
-
-				ack_no = ((u32)tcp_hdr_ptr[8] << 24) +
-					 ((u32)tcp_hdr_ptr[9] << 16) +
-					 ((u32)tcp_hdr_ptr[10] << 8) +
-					 (u32)tcp_hdr_ptr[11];
-
+				seq_no = ntohl(tcp_hdr_ptr->seq);
+				ack_no = ntohl(tcp_hdr_ptr->ack_seq);
 				for (i = 0; i < tcp_session; i++) {
 					u32 j = ack_session_info[i].seq_num;
 
-- 
2.17.1
