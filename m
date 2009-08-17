Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 33/33] wireless: remove mac80211 rate selection extra menu
Date: Mon, 17 Aug 2009 13:27:32 -0400
Message-Id: <1250530052-14783-34-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can just display this upon enabling mac80211 with an
'if MAC80211 != n' check.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 72006f9..8300d19 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -26,8 +26,7 @@ config MAC80211
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
 
-menu "Rate control algorithm selection"
-	depends on MAC80211 != n
+if MAC80211 != n
 
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EMBEDDED
@@ -74,7 +73,7 @@ config MAC80211_RC_DEFAULT
 	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""
 
-endmenu
+endif
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-- 
1.6.2.5

