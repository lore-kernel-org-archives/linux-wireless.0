Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbZHNU3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:29:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 31/34] wireless: update mac80211 kconfig entry
Date: Fri, 14 Aug 2009 16:25:56 -0400
Message-Id: <1250281559-13041-32-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the mac80211 kconfig entry to clarify
what it is and refer people to our wireless wiki for
more documentation.

Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/Kconfig |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 9db4ff8..d4d3dca 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,5 +1,5 @@
 config MAC80211
-	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
+	tristate "mac80211 - SoftMAC device support"
 	depends on CFG80211
 	select CRYPTO
 	select CRYPTO_ECB
@@ -7,8 +7,27 @@ config MAC80211
 	select CRYPTO_AES
 	select CRC32
 	---help---
-	  This option enables the hardware independent IEEE 802.11
-	  networking stack.
+	  This option enables support for a framework used by IEEE-802.11
+	  SoftMAC devices. SoftMAC devices allow for a finer control of the
+	  hardware, allowing for 802.11 frame management to be done in software
+	  for them, for both parsing and generation of 802.11 wireless frames.
+	  Most 802.11 devices today tend to be of this type.
+
+	  mac8011 implements the cfg80211 callbacks for SoftMAC devices,
+	  mac80211 then depends on cfg80211 for both registration to the networking
+	  subsystem and for configuration. Configuration is handled by cfg80211 both
+	  through nl80211 and wireless extensions.
+
+	  If you have new userspace utitlities which support nl80211 you do not
+	  need wireless-extensions to support a mac80211 device.
+
+	  For more information refer the the wireless wiki entry on mac80211:
+
+	  http://wireless.kernel.org/en/developers/Documentation/mac80211
+
+	  When built as a module mac80211 will be built as mac80211.ko, if not sure
+	  you should build this as a module.
+
 
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
-- 
1.6.2.5

