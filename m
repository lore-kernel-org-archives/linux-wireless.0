Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38121 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1KXINe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 03:13:34 -0500
Received: by bke11 with SMTP id 11so2634032bke.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 00:13:33 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, gwingerde@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Pass BlockAck and BlackAckReq frames to mac80211 in monitor mode
Date: Thu, 24 Nov 2011 09:13:26 +0100
Message-Id: <1322122406-10242-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111124_091338_089995_CD0CE78D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously BlockAcks were always dropped by the rt2800 hardware while
BlockAckReqs were always accepted. However, both are only useful on
monitor interfaces at the moment and both are control frames. So
pass them up when mac80211 sets FIF_CONTROL.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1ba079d..e5df380 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1203,8 +1203,10 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
 			   !(filter_flags & FIF_PSPOLL));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA,
+			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR,
+			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
 			   !(filter_flags & FIF_CONTROL));
 	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
-- 
1.7.3.4

