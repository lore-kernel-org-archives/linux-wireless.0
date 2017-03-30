Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:32886 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933197AbdC3KQF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 06:16:05 -0400
From: Johan Hovold <johan@kernel.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vincent Cuissard <cuissard@marvell.com>
Subject: [PATCH v2 6/8] NFC: nfcmrvl_uart: fix device-node leak during probe
Date: Thu, 30 Mar 2017 12:15:40 +0200
Message-Id: <20170330101542.15384-7-johan@kernel.org> (sfid-20170330_122204_431181_39F40379)
In-Reply-To: <20170330101542.15384-1-johan@kernel.org>
References: <20170330101542.15384-1-johan@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure to release the device-node reference when done parsing the
node.

Fixes: e097dc624f78 ("NFC: nfcmrvl: add UART driver")
Cc: Vincent Cuissard <cuissard@marvell.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/nfc/nfcmrvl/uart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index 6c0c301611c4..91162f8e0366 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -84,6 +84,7 @@ static int nfcmrvl_uart_parse_dt(struct device_node *node,
 	ret = nfcmrvl_parse_dt(matched_node, pdata);
 	if (ret < 0) {
 		pr_err("Failed to get generic entries\n");
+		of_node_put(matched_node);
 		return ret;
 	}
 
@@ -97,6 +98,8 @@ static int nfcmrvl_uart_parse_dt(struct device_node *node,
 	else
 		pdata->break_control = 0;
 
+	of_node_put(matched_node);
+
 	return 0;
 }
 
-- 
2.12.2
