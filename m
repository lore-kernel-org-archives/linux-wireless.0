Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 32/33] wireless: update mac80211 kconfig entry
Date: Mon, 17 Aug 2009 13:27:31 -0400
Message-Id: <1250530052-14783-33-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the mac80211 kconfig entry to clarify
what it is and refer people to our wireless wiki for
more documentation.

Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/Kconfig |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 9db4ff8..72006f9 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,5 +1,5 @@
 config MAC80211
-	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
+	tristate "mac80211 - SoftMAC device support"
 	depends on CFG80211
 	select CRYPTO
 	select CRYPTO_ECB
@@ -7,8 +7,21 @@ config MAC80211
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
+	  If you have new userspace utitlities which support nl80211 you do not
+	  need wireless-extensions to support a mac80211 device.
+
+	  For more information refer the the wireless wiki entry on mac80211:
+
+	  http://wireless.kernel.org/en/developers/Documentation/mac80211
+
+	  When built as a module mac80211 will be built as mac80211, if not sure
+	  you should build this as a module.
 
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
-- 
1.6.2.5

