Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10865 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbZIAPWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:55 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/7] wireless: update WIRELESS_EXT kconfig entry
Date: Tue, 1 Sep 2009 08:22:44 -0700
Message-ID: <1251818566-9264-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide more documentation as to why its being deprecated.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/Kconfig |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 08f6733..521ef6a 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -98,8 +98,16 @@ config WIRELESS_EXT
 	bool "Wireless extensions"
 	default y
 	---help---
-	  This option enables the legacy wireless extensions
-	  (wireless network interface configuration via ioctls.)
+	  This option enables the legacy wireless extensions.
+	  Wireless extensions was the first 802.11 wireless configuration
+	  API used by the networking subsystem. You will not need this unless
+	  you have old userspace utilities or old wireless devices which
+	  have not yet been ported to cfg80211.
+
+	  Wireless extensions is being deprecated in favor for cfg80211. For
+	  information regarding why see the wireless wiki:
+
+	  http://wireless.kernel.org/en/developers/Documentation/Wireless-Extensions
 
 	  Say Y unless you've upgraded all your userspace to use
 	  nl80211 instead of wireless extensions.
-- 
1.6.3.3

