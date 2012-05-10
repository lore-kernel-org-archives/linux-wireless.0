Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43685 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab2EJJRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so250127wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Assaf Azulay <assaf@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 78/78] wl18xx: change default tcp_checksum to false
Date: Thu, 10 May 2012 12:14:23 +0300
Message-Id: <1336641263-5761-79-git-send-email-arik@wizery.com> (sfid-20120510_111731_208311_2C08F8F5)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Azulay <assaf@ti.com>

as tcp check sum is going to be removed from firmware, and as
there is a problem with getting dns in security when checksum is
enabled, it was decided to disable it by default.
for none security modes it can be enabled by module paramenter.

Signed-off-by: Assaf Azulay <assaf@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5053c05..dda9c18 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -47,7 +47,7 @@ static char *board_type_param = "hdk";
 static bool dc2dc_param = false;
 static int n_antennas_2_param = 1;
 static int n_antennas_5_param = 1;
-static bool checksum_param = true;
+static bool checksum_param = false;
 static bool enable_11a_param = true;
 static int low_band_component = -1;
 static int low_band_component_type = -1;
@@ -1252,7 +1252,7 @@ module_param_named(n_antennas_5, n_antennas_5_param, uint, S_IRUSR);
 MODULE_PARM_DESC(n_antennas_5, "Number of installed 5GHz antennas: 1 (default) or 2");
 
 module_param_named(checksum, checksum_param, bool, S_IRUSR);
-MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to true)");
+MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to false)");
 
 module_param_named(enable_11a, enable_11a_param, bool, S_IRUSR);
 MODULE_PARM_DESC(enable_11a, "Enable 11a (5GHz): boolean (defaults to true)");
-- 
1.7.9.5

