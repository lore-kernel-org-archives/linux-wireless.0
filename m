Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53852 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbeIDLEZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 16/26] staging: wilc1000: use lowercase for get_BSSID() and HIL variable
Date: Tue, 4 Sep 2018 12:09:32 +0530
Message-ID: <1536043182-19735-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084103_623165_535E0758)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use lowercase name for get_BSSID() and HIL variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c        | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e542067..d6d3a97 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -116,7 +116,7 @@ static inline void get_address3(u8 *msa, u8 *addr)
 	memcpy(addr, msa + 16, 6);
 }
 
-static inline void get_BSSID(u8 *data, u8 *bssid)
+static inline void get_bssid(u8 *data, u8 *bssid)
 {
 	if (get_from_ds(data) == 1)
 		get_address2(data, bssid);
@@ -233,7 +233,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	network_info->tsf_hi = tsf_lo | ((u64)tsf_hi << 32);
 
 	get_ssid(msa, network_info->ssid, &network_info->ssid_len);
-	get_BSSID(msa, network_info->bssid);
+	get_bssid(msa, network_info->bssid);
 
 	network_info->ch = get_current_channel_802_11n(msa, rx_len
 						       + FCS_LEN);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index bf45b4c..d397c27 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -164,7 +164,7 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	struct wilc *wilc = vif->wilc;
 	const struct iphdr *ip_hdr_ptr;
 	const struct tcphdr *tcp_hdr_ptr;
-	u32 IHL, total_length, data_offset;
+	u32 ihl, total_length, data_offset;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
@@ -176,12 +176,12 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	if (ip_hdr_ptr->protocol != IPPROTO_TCP)
 		goto out;
 
-	IHL = ip_hdr_ptr->ihl << 2;
-	tcp_hdr_ptr = buffer + ETH_HLEN + IHL;
+	ihl = ip_hdr_ptr->ihl << 2;
+	tcp_hdr_ptr = buffer + ETH_HLEN + ihl;
 	total_length = ntohs(ip_hdr_ptr->tot_len);
 
 	data_offset = tcp_hdr_ptr->doff << 2;
-	if (total_length == (IHL + data_offset)) {
+	if (total_length == (ihl + data_offset)) {
 		u32 seq_no, ack_no;
 
 		seq_no = ntohl(tcp_hdr_ptr->seq);
-- 
2.7.4
