Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab1GMIqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:46:39 -0400
Subject: [TODO] iwmc3200wifi: remove wext includes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 10:46:54 +0200
Message-ID: <1310546814.3873.5.camel@jlt3.sipsolutions.net> (sfid-20110713_104642_809908_99B36040)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not possible right now due to the use of
struct iw_statistics, but that shouldn't
be used in cfg80211 drivers.

Needs more work before it can be applied!!

Cc: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    3 +--
 drivers/net/wireless/iwmc3200wifi/commands.c |    1 -
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    5 +++--
 drivers/net/wireless/iwmc3200wifi/main.c     |    1 -
 drivers/net/wireless/iwmc3200wifi/rx.c       |    2 --
 5 files changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2011-07-13 10:16:26.000000000 +0200
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2011-07-13 10:29:06.000000000 +0200
@@ -25,7 +25,6 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
 #include <net/cfg80211.h>
@@ -147,7 +146,7 @@ static int iwm_key_init(struct iwm_key *
 
 	if (params) {
 		if (params->key_len > WLAN_MAX_KEY_LEN ||
-		    params->seq_len > IW_ENCODE_SEQ_MAX_SIZE)
+		    params->seq_len > IWM_SEQ_SIZE)
 			return -EINVAL;
 
 		key->cipher = params->cipher;
--- a/drivers/net/wireless/iwmc3200wifi/commands.c	2011-07-13 10:16:26.000000000 +0200
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c	2011-07-13 10:29:06.000000000 +0200
@@ -37,7 +37,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/sched.h>
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h	2011-07-13 10:16:26.000000000 +0200
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h	2011-07-13 10:29:06.000000000 +0200
@@ -40,7 +40,6 @@
 #define __IWM_H__
 
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/cfg80211.h>
 
 #include "debug.h"
@@ -164,11 +163,13 @@ struct iwm_umac_key_hdr {
 	u8 multicast; /* BCast encrypt & BCast decrypt of frames FROM mac */
 } __packed;
 
+#define IWM_SEQ_SIZE	8
+
 struct iwm_key {
 	struct iwm_umac_key_hdr hdr;
 	u32 cipher;
 	u8 key[WLAN_MAX_KEY_LEN];
-	u8 seq[IW_ENCODE_SEQ_MAX_SIZE];
+	u8 seq[IWM_SEQ_SIZE];
 	int key_len;
 	int seq_len;
 };
--- a/drivers/net/wireless/iwmc3200wifi/main.c	2011-07-13 10:16:26.000000000 +0200
+++ b/drivers/net/wireless/iwmc3200wifi/main.c	2011-07-13 10:29:06.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/ieee80211.h>
-#include <linux/wireless.h>
 #include <linux/slab.h>
 
 #include "iwm.h"
--- a/drivers/net/wireless/iwmc3200wifi/rx.c	2011-07-13 10:16:26.000000000 +0200
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c	2011-07-13 10:29:06.000000000 +0200
@@ -40,12 +40,10 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <net/iw_handler.h>
 
 #include "iwm.h"
 #include "debug.h"


