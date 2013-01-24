Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:44147 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab3AXVAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:00:09 -0500
Date: Thu, 24 Jan 2013 22:00:28 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 2/4] rt2x00: remove NOTICE
Message-ID: <20130124210028.GA22800@localhost.localdomain> (sfid-20130124_220012_876114_B93F9E12)
References: <20130124205931.GB16252@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124205931.GB16252@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use this macro only on 3 places - remove it and replace by other
appropriate macros for printing messages.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a1de95e..1791260 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -80,7 +80,7 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rf(rt2x00dev, RF3022))
 		return true;
 
-	NOTICE(rt2x00dev, "Unknown RF chipset on rt305x\n");
+	INFO(rt2x00dev, "Unknown RF chipset on rt305x\n");
 	return false;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8ef11b6..ad73942 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -89,8 +89,6 @@
 	DEBUG_PRINTK_PROBE(KERN_ERR, "Error", __msg, ##__args)
 #define WARNING(__dev, __msg, __args...) \
 	DEBUG_PRINTK_MSG(__dev, KERN_WARNING, "Warning", __msg, ##__args)
-#define NOTICE(__dev, __msg, __args...) \
-	DEBUG_PRINTK_MSG(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
 #define INFO(__dev, __msg, __args...) \
 	DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
 #define DEBUG(__dev, __msg, __args...) \
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 96fffe8..07a9e10 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1440,7 +1440,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 #ifdef CONFIG_PM
 int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 {
-	NOTICE(rt2x00dev, "Going to sleep.\n");
+	DEBUG(rt2x00dev, "Going to sleep.\n");
 
 	/*
 	 * Prevent mac80211 from accessing driver while suspended.
@@ -1480,7 +1480,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
 
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 {
-	NOTICE(rt2x00dev, "Waking up.\n");
+	DEBUG(rt2x00dev, "Waking up.\n");
 
 	/*
 	 * Restore/enable extra components.
-- 
1.7.4.4

