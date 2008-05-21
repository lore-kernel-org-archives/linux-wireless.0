Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:49306 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758616AbYEULpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 07:45:13 -0400
From: Michael Bernhard <michael.bernhard@bfh.ch>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-2.6: Correct typo
Date: Wed, 21 May 2008 13:45:30 +0200
Message-Id: <12113703302992-git-send-email-michael.bernhard@bfh.ch> (sfid-20080521_133859_707809_ABB30CA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Bernhard <michael.bernhard@bfh.ch>
---
Apparently the compat tree was not compiled with a 2.6.22 Kernel.
This patch fixes a small typo.

 compat/compat.diff |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 596087e..b129963 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -561,7 +561,7 @@
  			struct ieee80211_rx_status rx_status = {0};
  
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
-+			if (priv->revid < < ADM8211_REV_CA)
++			if (priv->revid < ADM8211_REV_CA)
 +#else
  			if (priv->pdev->revision < ADM8211_REV_CA)
 +#endif
-- 
1.5.2.5

