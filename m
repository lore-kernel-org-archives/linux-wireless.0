Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38597 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] Add "wlan" and "ultrawideband" as aliases for "wifi" and "uwb".
Date: Fri, 22 Jan 2010 23:35:25 +0000
Message-Id: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tend to think "wlan" rather than "wifi"; also, it fits in nicely with "wwan".
Also, these aliases are what the kernel uses.
---
 rfkill.8 |    3 ++-
 rfkill.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/rfkill.8 b/rfkill.8
index da06b27..612e366 100644
--- a/rfkill.8
+++ b/rfkill.8
@@ -22,7 +22,8 @@ List the current state of all available rfkill-using devices.
 .TP
 .BI block " index|type"
 Disable the device corresponding to the given index.
-\fItype\fR is one of "all", "wifi", "bluetooth", "uwb", "wimax", "wwan" or "gps".
+\fItype\fR is one of "all", "wifi", "wlan", "bluetooth", "uwb",
+"ultrawideband", "wimax", "wwan" or "gps".
 .TP
 .BI unblock " index|type"
 Enable the device corresponding to the given index. If the device is
diff --git a/rfkill.c b/rfkill.c
index 3f71181..7b44b5a 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -200,8 +200,10 @@ struct rfkill_type_str {
 static struct rfkill_type_str rfkill_type_strings[] = {
 	{	.type = RFKILL_TYPE_ALL,		.name = "all"	},
 	{	.type = RFKILL_TYPE_WLAN,		.name = "wifi"	},
+	{	.type = RFKILL_TYPE_WLAN,		.name = "wlan"	}, /* alias */
 	{	.type = RFKILL_TYPE_BLUETOOTH,	.name = "bluetooth"	},
 	{	.type = RFKILL_TYPE_UWB,		.name = "uwb"	},
+	{	.type = RFKILL_TYPE_UWB,		.name = "ultrawideband"	}, /* alias */
 	{	.type = RFKILL_TYPE_WIMAX,		.name = "wimax"	},
 	{	.type = RFKILL_TYPE_WWAN,		.name = "wwan"	},
 	{	.type = RFKILL_TYPE_GPS,		.name = "gps"	},
@@ -222,7 +224,7 @@ static enum rfkill_type rfkill_str_to_type(char *s)
 
 static const char *argv0;
 
-#define BLOCK_PARAMS "{<idx>,all,wifi,bluetooth,uwb,wimax,wwan,gps}"
+#define BLOCK_PARAMS "{<idx>,all,wifi,wlan,bluetooth,uwb,ultrawideband,wimax,wwan,gps}"
 
 static void usage(void)
 {
-- 
1.6.5

