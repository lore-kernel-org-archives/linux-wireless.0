Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33332 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZKZFqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 00:46:55 -0500
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] acer-wmi: Add DMI quirk to blacklist Acer Aspire One BA01-DV/JM11-ML.
Date: Thu, 26 Nov 2009 13:46:53 +0800
Message-Id: <1259214413-21956-1-git-send-email-keng-yu.lin@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two Acer Aspire One models should be blacklisted to prevent from
reporting rfkill is enabled since it's hardware controlled.

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/platform/x86/acer-wmi.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 454970d..b39766c 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -241,6 +241,20 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
 		},
 	},
+	{
+		.ident = "Acer Aspire One (BA01-DV)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AO531h"),
+		},
+	},
+	{
+		.ident = "Acer Aspire One (JM11-ML)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AO751h"),
+		},
+	},
 	{}
 };
 
-- 
1.6.3.3

