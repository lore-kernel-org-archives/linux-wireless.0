Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:1228 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYJNQiC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:38:02 -0400
Received: from sepang.rtg.net (unknown [10.0.2.5])
	by mail.tpi.com (Postfix) with ESMTP id 99B42DF672
	for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 09:38:01 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ipw2200: change default policy for auto-associate
Message-Id: <20081014163803.AD89B5A1D8@sepang.rtg.net> (sfid-20081014_183808_310105_878EAE1C)
Date: Tue, 14 Oct 2008 10:38:03 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 6f6a49200c74553acac806b6987d5c661346ca00 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 14 Oct 2008 10:30:33 -0600
Subject: [PATCH v2] ipw2200: change default policy for auto-associate

Do not attempt association until directed to do so by a user space
application. In particular, this avoids race conditions with
NetworkManager association state.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 Documentation/networking/README.ipw2200 |    2 +-
 drivers/net/wireless/ipw2200.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
index 4f2a40f..80c7285 100644
--- a/Documentation/networking/README.ipw2200
+++ b/Documentation/networking/README.ipw2200
@@ -147,7 +147,7 @@ Where the supported parameter are:
 	driver.  If disabled, the driver will not attempt to scan 
 	for and associate to a network until it has been configured with 
 	one or more properties for the target network, for example configuring 
-	the network SSID.  Default is 1 (auto-associate)
+	the network SSID.  Default is 0 (do not auto-associate)
 	
 	Example: % modprobe ipw2200 associate=0
 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..eb1230e 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -87,7 +87,7 @@ static int channel = 0;
 static int mode = 0;
 
 static u32 ipw_debug_level;
-static int associate = 1;
+static int associate;
 static int auto_create = 1;
 static int led = 0;
 static int disable = 0;
-- 
1.5.6.3

