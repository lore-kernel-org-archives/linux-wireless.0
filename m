Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65375 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0IHS6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:58:06 -0400
Received: by eyb6 with SMTP id 6so346757eyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 11:58:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Lars Ericsson <lars_ericsson@telia.com>
Subject: [PATCH 01/06] rt2x00: Antenna diversity does not work in 2.6.35
Date: Wed, 8 Sep 2010 20:55:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009082055.38033.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lars Ericsson <lars_ericsson@telia.com>

The test if antenna diversity is at all enabled uses a local variable
'flags' to prepare the test condition, but uses 'ant->flags' when the test
is evaluated. The effect is that the diversity evaluation will never start.
I can see two solutions, use the 'flag' in the test condition or revert the
local flag change. My attached patch took alternative two.

Then the evaluation start but it will still not switch antenna. The problem
is a code section in rt2x00lib_config_antenna (). The effect of that code
section is that any change the diversity function perform will be
effectively shorten and no antenna selection command issued. The attached
patch will filter out any ANTENNA_SW_DIVERSITY setting but forward all
other

Signed-off-by: Lars Ericsson <lars_ericsson@telia.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00link.c   |   12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 34f34fa..db09a64 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -129,12 +129,12 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY))
 		config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
-	else
+	else if(config.rx == ANTENNA_SW_DIVERSITY)
 		config.rx = active->rx;
 
 	if (!(ant->flags & ANTENNA_TX_DIVERSITY))
 		config.tx = rt2x00lib_config_antenna_check(config.tx, def->tx);
-	else
+	else if (config.tx == ANTENNA_SW_DIVERSITY)
 		config.tx = active->tx;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 666cef3..4d534e9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -188,7 +188,6 @@ static void rt2x00lib_antenna_diversity_eval(struct rt2x00_dev *rt2x00dev)
 static bool rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 {
 	struct link_ant *ant = &rt2x00dev->link.ant;
-	unsigned int flags = ant->flags;
 
 	/*
 	 * Determine if software diversity is enabled for
@@ -196,13 +195,13 @@ static bool rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 	 * Always perform this check since within the link
 	 * tuner interval the configuration might have changed.
 	 */
-	flags &= ~ANTENNA_RX_DIVERSITY;
-	flags &= ~ANTENNA_TX_DIVERSITY;
+	ant->flags &= ~ANTENNA_RX_DIVERSITY;
+	ant->flags &= ~ANTENNA_TX_DIVERSITY;
 
 	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
-		flags |= ANTENNA_RX_DIVERSITY;
+		ant->flags |= ANTENNA_RX_DIVERSITY;
 	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-		flags |= ANTENNA_TX_DIVERSITY;
+		ant->flags |= ANTENNA_TX_DIVERSITY;
 
 	if (!(ant->flags & ANTENNA_RX_DIVERSITY) &&
 	    !(ant->flags & ANTENNA_TX_DIVERSITY)) {
@@ -210,9 +209,6 @@ static bool rt2x00lib_antenna_diversity(struct rt2x00_dev *rt2x00dev)
 		return true;
 	}
 
-	/* Update flags */
-	ant->flags = flags;
-
 	/*
 	 * If we have only sampled the data over the last period
 	 * we should now harvest the data. Otherwise just evaluate
-- 
1.7.2.2

