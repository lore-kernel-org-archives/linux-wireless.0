Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39087 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1DRNpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:35 -0400
Received: by wya21 with SMTP id 21so3921355wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:45:34 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: "Luciano Coelho" <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl12xx: Enable dynamic memory for 127x
Date: Mon, 18 Apr 2011 16:45:10 +0300
Message-Id: <1303134310-31592-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FW can dynamically manage its internal TX & RX memory pools, moving
blocks from one pool to another when necessary. This can significantly
improve performance. Currently this feature is enabled only for 128x.

Enable dynamic memory for 127x as well. Other parameters in the memory
configuration structure may need to be fine tuned, as the optimal values
for these may change once dynamic memory is enabled.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..d32ffa4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -304,7 +304,7 @@ static struct conf_drv_settings default_conf = {
 		.ssid_profiles                = 1,
 		.rx_block_num                 = 70,
 		.tx_min_block_num             = 40,
-		.dynamic_memory               = 0,
+		.dynamic_memory               = 1,
 		.min_req_tx_blocks            = 100,
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
-- 
1.7.1

