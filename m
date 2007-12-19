Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15777 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751129AbXLSGRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:17:16 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/6] rtl8180: Set CRC failed flag
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 19 Dec 2007 01:17:35 -0500
Message-ID: <20071219061735.4885.5711.stgit@tetra.sourmilk.net> (sfid-20071219_061721_115232_8FE3E887)
In-Reply-To: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
References: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

Frames that fail CRC need RX_FLAG_FAILED_FCS_CRC set.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 91c1d9b..058f30f 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -104,6 +104,9 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.phymode = dev->conf.phymode;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
 			rx_status.flag |= RX_FLAG_TSFT;
+			if (flags & RTL8180_RX_DESC_FLAG_CRC32_ERR)
+				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
 			skb = new_skb;


