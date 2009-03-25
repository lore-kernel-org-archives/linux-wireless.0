Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbZCYBVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 21:21:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: defautl CONFIG_WIRELESS_OLD_REGULATORY to n
Date: Tue, 24 Mar 2009 21:21:07 -0400
Message-Id: <1237944068-3682-1-git-send-email-lrodriguez@atheros.com> (sfid-20090325_022120_783640_25B9A003)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And update description and feature-removal schedule according
to the new plan.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/feature-removal-schedule.txt |   13 +++++++---
 net/wireless/Kconfig                       |   37 +++++++---------------------
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 020bc66..d0914e3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -7,7 +7,7 @@ be removed from this file.
 ---------------------------
 
 What:	The ieee80211_regdom module parameter
-When:	March 2010
+When:	March 2010 / desktop catchup
 
 Why:	This was inherited by the CONFIG_WIRELESS_OLD_REGULATORY code,
 	and currently serves as an option for users to define an
@@ -30,18 +30,23 @@ Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
 
-What:	old static regulatory information
-When:	2.6.29
+What:	CONFIG_WIRELESS_OLD_REGULATORY - old static regulatory information
+When:	March 2010 / desktop catchup
+
 Why:	The old regulatory infrastructure has been replaced with a new one
 	which does not require statically defined regulatory domains. We do
 	not want to keep static regulatory domains in the kernel due to the
 	the dynamic nature of regulatory law and localization. We kept around
 	the old static definitions for the regulatory domains of:
+
 		* US
 		* JP
 		* EU
+
 	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
-	set.
+	set. We will remove this option once the standard Linux desktop catches
+	up with the new userspace APIs we have implemented.
+
 Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index d1d18f3..3c3bc9e 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -12,36 +12,17 @@ config CFG80211_REG_DEBUG
 
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
-	default y
+	default n
 	---help---
 	  This option enables the old static regulatory information
-	  and uses it within the new framework. This is available
-	  temporarily as an option to help prevent immediate issues
-	  due to the switch to the new regulatory framework which
-	  does require a new userspace application which has the
-	  database of regulatory information (CRDA) and another for
-	  setting regulatory domains (iw).
-
-	  For more information see:
-
-	  http://wireless.kernel.org/en/developers/Regulatory/CRDA
-	  http://wireless.kernel.org/en/users/Documentation/iw
-
-	  It is important to note though that if you *do* have CRDA present
-	  and if this option is enabled CRDA *will* be called to update the
-	  regulatory domain (for US and JP only). Support for letting the user
-	  set the regulatory domain through iw is also supported. This option
-	  mainly exists to leave around for a kernel release some old static
-	  regulatory domains that were defined and to keep around the old
-	  ieee80211_regdom module parameter. This is being phased out and you
-	  should stop using them ASAP.
-
-	  Note: You will need CRDA if you want 802.11d support
-
-	  Say Y unless you have installed a new userspace application.
-	  Also say Y if have one currently depending on the ieee80211_regdom
-	  module parameter and cannot port it to use the new userspace
-	  interfaces.
+	  and uses it within the new framework. This option is available
+	  for historical reasons and it is advised to leave it off.
+
+	  For details see:
+
+	  http://wireless.kernel.org/en/developers/Regulatory
+
+	  Say N and if you say Y, please tell us why. The default is N.
 
 config WIRELESS_EXT
 	bool "Wireless extensions"
-- 
1.6.0.6

