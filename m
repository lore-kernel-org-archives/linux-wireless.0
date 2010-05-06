Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52386 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0EFK35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 06:29:57 -0400
Received: by bwz19 with SMTP id 19so400457bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 03:29:56 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/3] rt2x00: rt2800: don't overwrite SIFS values on erp changes
Date: Thu, 6 May 2010 12:29:44 +0200
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061229.44923.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SIFS value is a constant and doesn't need to be updated on erp changes.
Furthermore the code used 10us for both, the OFDM SIFS and CCK SIFS time
which broke CTS protected 11g connections (see patch "rt2x00: rt2800: update
initial SIFS values" for details).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f786068..858455f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -640,8 +640,6 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
 	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
 
-- 
1.6.4.2

