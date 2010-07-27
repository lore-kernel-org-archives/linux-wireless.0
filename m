Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0G0OsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 10:48:13 -0400
Date: Tue, 27 Jul 2010 10:48:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, sgruszka@redhat.com,
	Gertjan van Wingerde <gwingerde@gmail.com>
Message-Id: <20100727144804.6012.94740.send-patch@dhcp-lab-109.englab.brq.redhat.com>
Subject: [PATCH w-t 1/3] rt2500usb: write keys to proper registers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix rt2500usb hardware encryption broken by commit
96b61bafe22b2f2abcc833d651739edb977f1b1e
"rt2x00: Clean up USB vendor request buffer functions"

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 4b2fef3..7892647 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -376,7 +376,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 		if (key->hw_key_idx > 0 && crypto->cipher != curr_cipher)
 			return -EOPNOTSUPP;
 
-		rt2500usb_register_multiwrite(rt2x00dev, reg,
+		rt2500usb_register_multiwrite(rt2x00dev, KEY_ENTRY(key->hw_key_idx),
 					      crypto->key, sizeof(crypto->key));
 
 		/*
-- 
1.7.1

