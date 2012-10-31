Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:50360 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2JaSw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 14:52:57 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so771374dak.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 11:52:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH] carl9170: kill MODULE_VERSION
Date: Wed, 31 Oct 2012 11:52:51 -0700
Message-Id: <1351709571-23301-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20121031_195300_925486_3CD82687)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This is pretty pointless. Lets kill this to stop people from
thinking that its actually used. Maybe we should go on
a crusade and kill this completely from the kernel.

Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/carl9170/fw.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 24ac287..aaebecd 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -28,11 +28,6 @@
 #include "fwcmd.h"
 #include "version.h"
 
-#define MAKE_STR(symbol) #symbol
-#define TO_STR(symbol) MAKE_STR(symbol)
-#define CARL9170FW_API_VER_STR TO_STR(CARL9170FW_API_MAX_VER)
-MODULE_VERSION(CARL9170FW_API_VER_STR ":" CARL9170FW_VERSION_GIT);
-
 static const u8 otus_magic[4] = { OTUS_MAGIC };
 
 static const void *carl9170_fw_find_desc(struct ar9170 *ar, const u8 descid[4],
-- 
1.7.10.4

