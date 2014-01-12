Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1177 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaALIlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 03:41:22 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 3/3] wil6210: prefetch head of packet
Date: Sun, 12 Jan 2014 10:41:04 +0200
Message-ID: <1389516065-19515-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140112_094132_009194_979CBF22)
In-Reply-To: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1389516065-19515-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as skb is ready to be reaped, prefetch 1-st cache line.
This accelerates data access that is performed later, during the
packet classification by the driver and IP stack.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 18003c0..0b0975d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -21,6 +21,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
+#include <linux/prefetch.h>
 
 #include "wil6210.h"
 #include "wmi.h"
@@ -377,6 +378,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	}
 	skb_trim(skb, dmalen);
 
+	prefetch(skb->data);
+
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
-- 
1.8.3.2

