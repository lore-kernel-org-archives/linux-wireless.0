Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16110 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1GVFne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 25/31] ath6kl: Avoid two memset to clear src and desr mac addr variable memory in ath6kl_wmi_dot11_hdr_remove()
Date: Fri, 22 Jul 2011 08:41:58 +0300
Message-ID: <1311313324-6766-27-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074338_113613_A1437C94)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a52d7d2..6e4febf 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -317,9 +317,8 @@ int ath6kl_wmi_dot11_hdr_remove(struct wmi *wmi, struct sk_buff *skb)
 	datap = skb->data;
 	llc_hdr = (struct ath6kl_llc_snap_hdr *)(datap);
 
+	memset(&eth_hdr, 0, sizeof(eth_hdr));
 	eth_hdr.h_proto = llc_hdr->eth_type;
-	memset(eth_hdr.h_dest, 0, sizeof(eth_hdr.h_dest));
-	memset(eth_hdr.h_source, 0, sizeof(eth_hdr.h_source));
 
 	switch ((le16_to_cpu(wh.frame_control)) &
 		(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
-- 
1.7.1

