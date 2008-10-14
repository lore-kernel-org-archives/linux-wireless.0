Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3385 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYJNPVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 11:21:08 -0400
Received: from sepang.rtg.net (unknown [10.0.2.5])
	by mail.tpi.com (Postfix) with ESMTP id 44844D7CF7
	for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 07:56:57 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2200: Change driver default policies
Message-Id: <20081014145708.CAF215A1D8@sepang.rtg.net> (sfid-20081014_172114_553704_8295638B)
Date: Tue, 14 Oct 2008 08:57:08 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 41804698de6f2ce121c1452943b9ad2b8a54988b Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 14 Oct 2008 08:16:09 -0600
Subject: [PATCH] ipw2200: change default policies for auto-associate, auto-create, and auto-roaming

We now have applications available to set policy. This patch changes the driver defaults to:

1) associate=0 - do not automatically associate to an SSID.
2) auto_create=0 - do not automatically create an ad-hoc network
3) roaming=0 - do not automatically roam to another AP with the same SSID.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 Documentation/networking/README.ipw2200 |    6 +++---
 drivers/net/wireless/ipw2200.c          |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
index 4f2a40f..8f3e40d 100644
--- a/Documentation/networking/README.ipw2200
+++ b/Documentation/networking/README.ipw2200
@@ -147,14 +147,14 @@ Where the supported parameter are:
 	driver.  If disabled, the driver will not attempt to scan 
 	for and associate to a network until it has been configured with 
 	one or more properties for the target network, for example configuring 
-	the network SSID.  Default is 1 (auto-associate)
+	the network SSID.  Default is 0 (do not auto-associate)
 	
-	Example: % modprobe ipw2200 associate=0
+	Example: % modprobe ipw2200 associate=1
 
   auto_create
 	Set to 0 to disable the auto creation of an Ad-Hoc network 
 	matching the channel and network name parameters provided.  
-	Default is 1.
+	Default is 0.
 
   channel
 	channel number for association.  The normal method for setting
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..31f396b 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -87,13 +87,13 @@ static int channel = 0;
 static int mode = 0;
 
 static u32 ipw_debug_level;
-static int associate = 1;
-static int auto_create = 1;
+static int associate;
+static int auto_create;
 static int led = 0;
 static int disable = 0;
 static int bt_coexist = 0;
 static int hwcrypto = 0;
-static int roaming = 1;
+static int roaming;
 static const char ipw_modes[] = {
 	'a', 'b', 'g', '?'
 };
-- 
1.5.6.3

