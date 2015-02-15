Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbbBOMDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:14 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 9/9] wil6210: Align Rx buffers on 4*n+2
Date: Sun, 15 Feb 2015 14:02:38 +0200
Message-Id: <1424001758-29529-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130326_129536_DEF38768)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the normal (non-sniffer) mode of operation, align Rx buffer
on 4*n+2, so IP header (after 14 bytes of Ethernet header)
will start dword aligned. This accelerated IP stack a little bit.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7f2f560..e1587b3 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -468,8 +468,11 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 	struct vring *v = &wil->vring_rx;
 	u32 next_tail;
 	int rc = 0;
+	/* 2 bytes headroom in normal operation mode to achieve dword
+	 * alignment for the IP header
+	 */
 	int headroom = ndev->type == ARPHRD_IEEE80211_RADIOTAP ?
-			WIL6210_RTAP_SIZE : 0;
+			WIL6210_RTAP_SIZE : 2;
 
 	for (; next_tail = wil_vring_next_tail(v),
 			(next_tail != v->swhead) && (count-- > 0);
-- 
2.1.0

