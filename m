Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40799 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaAHJvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 04:51:11 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/3] wil6210: prefetch head of packet
Date: Wed, 8 Jan 2014 11:50:49 +0200
Message-ID: <1389174649-14077-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140108_105115_727753_2301C0A4)
In-Reply-To: <1389174649-14077-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1389174649-14077-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index 18003c0..9b88440 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -21,6 +21,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
+#include <asm/processor.h>
 
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

