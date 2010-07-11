Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41261 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0GKKcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:12 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so426224eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/17] rt2x00: Add missing TSF sync mode for AP operation
Date: Sun, 11 Jul 2010 12:30:13 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111229.27800.IvDoorn@gmail.com> <201007111229.50936.IvDoorn@gmail.com>
In-Reply-To: <201007111229.50936.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111230.14710.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Currently rt2x00 uses the TSF_SYNC_BEACON mode for all beaconing
interface types. However, TSF_SYNC_BEACON is meant for IBSS networks and
thus implements TSF merging in the hardware. Rename TSF_SYNC_BEACON to
TSF_SYNC_ADHOC to better express its purpose and introduce the missing
TSF sync mode TSF_SYNC_AP_NONE which should be used for beaconing modes
that don't need TSF merging.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c    |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +++-
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cfe199b..9587236 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -805,7 +805,8 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE,
-				   (conf->sync == TSF_SYNC_BEACON));
+				   (conf->sync == TSF_SYNC_ADHOC ||
+				    conf->sync == TSF_SYNC_AP_NONE));
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 		/*
@@ -813,7 +814,7 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 		 */
 		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
 		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER,
-				   (conf->sync == TSF_SYNC_BEACON));
+				   (conf->sync == TSF_SYNC_AP_NONE));
 		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
 
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 8dbd634..953dc4f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -41,10 +41,12 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
+		conf.sync = TSF_SYNC_ADHOC;
+		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_WDS:
-		conf.sync = TSF_SYNC_BEACON;
+		conf.sync = TSF_SYNC_AP_NONE;
 		break;
 	case NL80211_IFTYPE_STATION:
 		conf.sync = TSF_SYNC_INFRA;
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 055501c..cef9462 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -63,7 +63,8 @@ enum led_mode {
 enum tsf_sync {
 	TSF_SYNC_NONE = 0,
 	TSF_SYNC_INFRA = 1,
-	TSF_SYNC_BEACON = 2,
+	TSF_SYNC_ADHOC = 2,
+	TSF_SYNC_AP_NONE = 3,
 };
 
 /*
-- 
1.7.1.1

