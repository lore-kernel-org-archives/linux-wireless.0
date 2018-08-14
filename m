Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41351 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:03 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 16/24] staging: wilc1000: refactor tcp_process() to avoid extra leading tabs
Date: Tue, 14 Aug 2018 12:20:08 +0530
Message-ID: <1534229416-13254-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085117_626291_95FFB6E9)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor tcp_process() to avoid unnecessary leading tabs in the
function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 52 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6787b6e..bf45b4c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -162,42 +162,46 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
+	const struct iphdr *ip_hdr_ptr;
+	const struct tcphdr *tcp_hdr_ptr;
+	u32 IHL, total_length, data_offset;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (eth_hdr_ptr->h_proto == htons(ETH_P_IP)) {
-		const struct iphdr *ip_hdr_ptr = buffer + ETH_HLEN;
+	if (eth_hdr_ptr->h_proto != htons(ETH_P_IP))
+		goto out;
 
-		if (ip_hdr_ptr->protocol == IPPROTO_TCP) {
-			const struct tcphdr *tcp_hdr_ptr;
-			u32 IHL, total_length, data_offset;
+	ip_hdr_ptr = buffer + ETH_HLEN;
 
-			IHL = ip_hdr_ptr->ihl << 2;
-			tcp_hdr_ptr = buffer + ETH_HLEN + IHL;
-			total_length = ntohs(ip_hdr_ptr->tot_len);
+	if (ip_hdr_ptr->protocol != IPPROTO_TCP)
+		goto out;
 
-			data_offset = tcp_hdr_ptr->doff << 2;
-			if (total_length == (IHL + data_offset)) {
-				u32 seq_no, ack_no;
+	IHL = ip_hdr_ptr->ihl << 2;
+	tcp_hdr_ptr = buffer + ETH_HLEN + IHL;
+	total_length = ntohs(ip_hdr_ptr->tot_len);
 
-				seq_no = ntohl(tcp_hdr_ptr->seq);
-				ack_no = ntohl(tcp_hdr_ptr->ack_seq);
-				for (i = 0; i < tcp_session; i++) {
-					u32 j = ack_session_info[i].seq_num;
+	data_offset = tcp_hdr_ptr->doff << 2;
+	if (total_length == (IHL + data_offset)) {
+		u32 seq_no, ack_no;
 
-					if (i < 2 * MAX_TCP_SESSION &&
-					    j == seq_no) {
-						update_tcp_session(i, ack_no);
-						break;
-					}
-				}
-				if (i == tcp_session)
-					add_tcp_session(0, 0, seq_no);
+		seq_no = ntohl(tcp_hdr_ptr->seq);
+		ack_no = ntohl(tcp_hdr_ptr->ack_seq);
+		for (i = 0; i < tcp_session; i++) {
+			u32 j = ack_session_info[i].seq_num;
 
-				add_tcp_pending_ack(ack_no, i, tqe);
+			if (i < 2 * MAX_TCP_SESSION &&
+			    j == seq_no) {
+				update_tcp_session(i, ack_no);
+				break;
 			}
 		}
+		if (i == tcp_session)
+			add_tcp_session(0, 0, seq_no);
+
+		add_tcp_pending_ack(ack_no, i, tqe);
 	}
+
+out:
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 }
 
-- 
2.7.4
