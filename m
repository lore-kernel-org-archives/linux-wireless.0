Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54064 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZBUFUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:20:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 5/5] cfg80211: default OLD_REG to n
Date: Sat, 21 Feb 2009 00:20:41 -0500
Message-Id: <1235193641-17993-6-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062057_913634_B288E6C6)
In-Reply-To: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are not following the schedule to remove OLD_REG by 2.6.29
lets simply set it to default to n for 2.6.30 and schedule its
removal for 2.6.31

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/feature-removal-schedule.txt |    5 +++--
 net/wireless/Kconfig                       |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ac98851..bf83b02 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -7,7 +7,7 @@ be removed from this file.
 ---------------------------
 
 What:	old static regulatory information and ieee80211_regdom module parameter
-When:	2.6.29
+When:	2.6.31
 Why:	The old regulatory infrastructure has been replaced with a new one
 	which does not require statically defined regulatory domains. We do
 	not want to keep static regulatory domains in the kernel due to the
@@ -19,7 +19,8 @@ Why:	The old regulatory infrastructure has been replaced with a new one
 	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
 	set. We also kept around the ieee80211_regdom module parameter in case
 	some applications were relying on it. Changing regulatory domains
-	can now be done instead by using nl80211, as is done with iw.
+	can now be done instead by using nl80211, as is done with iw, or
+	wpa_supplicant.
 Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index e28e2b8..009f5b8 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -25,7 +25,7 @@ config NL80211
 
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
-	default y
+	default n
 	---help---
 	  This option enables the old static regulatory information
 	  and uses it within the new framework. This is available
-- 
1.6.0.3

