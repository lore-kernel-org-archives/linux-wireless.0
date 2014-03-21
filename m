Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57642 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaCUFe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 01:34:58 -0400
Received: by mail-pb0-f45.google.com with SMTP id uo5so1956836pbc.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 22:34:57 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: fix the peer mac address in getting stats
Date: Fri, 21 Mar 2014 13:34:36 +0800
Message-Id: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140321_063509_903482_7D16BCE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the macro to convert the MAC address from WMI word
format to char array has lead to the wrong peer mac
address printed out while retrieving the peer stats from
FW. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi.h   |   10 ----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6debd28..f95defa 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -252,8 +252,8 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 			peer_stats = (struct wmi_peer_stats *)tmp;
 			s = &stats->peer_stat[i];
 
-			WMI_MAC_ADDR_TO_CHAR_ARRAY(&peer_stats->peer_macaddr,
-						   s->peer_macaddr);
+			memcpy(s->peer_macaddr, &peer_stats->peer_macaddr.addr,
+			       ETH_ALEN);
 			s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
 			s->peer_tx_rate =
 				__le32_to_cpu(peer_stats->peer_tx_rate);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e78a7ad..084bcc5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -198,16 +198,6 @@ struct wmi_mac_addr {
 	} __packed;
 } __packed;
 
-/* macro to convert MAC address from WMI word format to char array */
-#define WMI_MAC_ADDR_TO_CHAR_ARRAY(pwmi_mac_addr, c_macaddr) do { \
-	(c_macaddr)[0] =  ((pwmi_mac_addr)->word0) & 0xff; \
-	(c_macaddr)[1] = (((pwmi_mac_addr)->word0) >> 8) & 0xff; \
-	(c_macaddr)[2] = (((pwmi_mac_addr)->word0) >> 16) & 0xff; \
-	(c_macaddr)[3] = (((pwmi_mac_addr)->word0) >> 24) & 0xff; \
-	(c_macaddr)[4] =  ((pwmi_mac_addr)->word1) & 0xff; \
-	(c_macaddr)[5] = (((pwmi_mac_addr)->word1) >> 8) & 0xff; \
-	} while (0)
-
 struct wmi_cmd_map {
 	u32 init_cmdid;
 	u32 start_scan_cmdid;
-- 
1.7.9.5

