Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:32944 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab0AMVUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:20:30 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: fix two return types
Date: Wed, 13 Jan 2010 22:20:17 +0100
Message-Id: <1263417619-30261-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a build error introduced in 7d2b68df6301937a8299bca8bef135ae951b569c:
/include/linux/compat-2.6.25.h:172: error: two or more data types in declaration specifiers

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.25.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index e0dfdf3..7188b8c 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -169,7 +169,7 @@ static inline int compat_pm_qos_power_init(void)
 	return 0;
 }
 
-static inline int int compat_pm_qos_power_deinit(void)
+static inline int compat_pm_qos_power_deinit(void)
 {
 	return 0;
 }
-- 
1.6.3.3

