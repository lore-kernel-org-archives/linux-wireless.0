Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:20547 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbXJMOKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:41 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1250541mue
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/11] rt2x00: Fix antenna selection.
Date: Sat, 13 Oct 2007 16:26:57 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710131621.05173.IvDoorn@gmail.com>
In-Reply-To: <200710131621.05173.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710131626.58183.IvDoorn@gmail.com> (sfid-20071013_151055_858306_B4D165C1)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

In the config() handler, make sure that we do configure an antenna if the
current active antenna is uninitialized. Furthermore, don't overwrite the
active antenna with bogus values if we didn't touch the antenna setup.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 2b0edd2..b4fad74 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -166,6 +166,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	else if (conf->antenna_sel_rx &&
 		 conf->antenna_sel_rx != active_ant->rx)
 		flags |= CONFIG_UPDATE_ANTENNA;
+	else if (active_ant->rx == ANTENNA_SW_DIVERSITY)
+		flags |= CONFIG_UPDATE_ANTENNA;
 
 	if (!conf->antenna_sel_tx &&
 	    default_ant->tx != ANTENNA_SW_DIVERSITY &&
@@ -174,6 +176,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	else if (conf->antenna_sel_tx &&
 		 conf->antenna_sel_tx != active_ant->tx)
 		flags |= CONFIG_UPDATE_ANTENNA;
+	else if (active_ant->tx == ANTENNA_SW_DIVERSITY)
+		flags |= CONFIG_UPDATE_ANTENNA;
 
 	/*
 	 * The following configuration options are never
@@ -262,11 +266,17 @@ config:
 	if (flags & (CONFIG_UPDATE_CHANNEL | CONFIG_UPDATE_ANTENNA))
 		rt2x00lib_reset_link_tuner(rt2x00dev);
 
-	rt2x00dev->curr_hwmode = libconf.phymode;
-	rt2x00dev->rx_status.phymode = conf->phymode;
+	if (flags & CONFIG_UPDATE_PHYMODE) {
+		rt2x00dev->curr_hwmode = libconf.phymode;
+		rt2x00dev->rx_status.phymode = conf->phymode;
+	}
+
 	rt2x00dev->rx_status.freq = conf->freq;
 	rt2x00dev->rx_status.channel = conf->channel;
 	rt2x00dev->tx_power = conf->power_level;
-	rt2x00dev->link.ant.active.rx = libconf.ant.rx;
-	rt2x00dev->link.ant.active.tx = libconf.ant.tx;
+
+	if (flags & CONFIG_UPDATE_ANTENNA) {
+		rt2x00dev->link.ant.active.rx = libconf.ant.rx;
+		rt2x00dev->link.ant.active.tx = libconf.ant.tx;
+	}
 }
-- 
1.5.3.4

