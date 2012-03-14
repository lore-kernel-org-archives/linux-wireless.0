Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030758Ab2CNKRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:17:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/5] rt2x00: rt2800usb: limit tx queues length
Date: Wed, 14 Mar 2012 11:16:21 +0100
Message-Id: <1331720181-18564-5-git-send-email-sgruszka@redhat.com> (sfid-20120314_111714_990650_6A5B45D7)
In-Reply-To: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX status fifo is limited to 16 elements. When we send more frames than
that, we can easily loose status, what is not good for rate scaling
algorithm.

On my testing the change does not degrade performance, actually make
is slightly better. Additionally with the patch I can see much less
various rt2x00 warnings in dmesg.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 8c1d2c0..cd490ab 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -870,7 +870,7 @@ static const struct data_queue_desc rt2800usb_queue_rx = {
 };
 
 static const struct data_queue_desc rt2800usb_queue_tx = {
-	.entry_num		= 64,
+	.entry_num		= 16,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
-- 
1.7.1

