Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3032 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYG0Mri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 08:47:38 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1392033nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 05:47:37 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Fix partial antenna configuration
Date: Sun, 27 Jul 2008 15:06:21 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807271505.38116.IvDoorn@gmail.com> <200807271506.05316.IvDoorn@gmail.com>
In-Reply-To: <200807271506.05316.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807271506.21999.IvDoorn@gmail.com> (sfid-20080727_144747_236078_A8650C86)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The if-statement to determine the new TX/RX antenna
configuration was incomplete. It lacks the general
else-clause when the antenna wasn't changed.

This is a correct event, since it can occur when only
one of the antenna's has been changed or when the new
configuration is being forced (like when the interface
has just been added).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 3f89516..d134c3b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -254,6 +254,8 @@ config:
 			libconf.ant.rx = default_ant->rx;
 		else if (active_ant->rx == ANTENNA_SW_DIVERSITY)
 			libconf.ant.rx = ANTENNA_B;
+		else
+			libconf.ant.rx = active_ant->rx;
 
 		if (conf->antenna_sel_tx)
 			libconf.ant.tx = conf->antenna_sel_tx;
@@ -261,6 +263,8 @@ config:
 			libconf.ant.tx = default_ant->tx;
 		else if (active_ant->tx == ANTENNA_SW_DIVERSITY)
 			libconf.ant.tx = ANTENNA_B;
+		else
+			libconf.ant.tx = active_ant->tx;
 	}
 
 	if (flags & CONFIG_UPDATE_SLOT_TIME) {
-- 
1.5.6.1

