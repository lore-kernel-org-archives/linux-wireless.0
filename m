Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbZHNUaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:30:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 33/34] wireless: remove mac80211 rate selection extra menu
Date: Fri, 14 Aug 2009 16:25:58 -0400
Message-Id: <1250281559-13041-34-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
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
index 6293b21..8e4c8cf 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -28,8 +28,7 @@ config MAC80211
 	  When built as a module mac80211 will be built as mac80211.ko, if not sure
 	  you should build this as a module.
 
-menu "Rate control algorithm selection"
-	depends on MAC80211 != n
+if MAC80211 != n
 
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EMBEDDED
@@ -76,7 +75,7 @@ config MAC80211_RC_DEFAULT
 	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""
 
-endmenu
+endif
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-- 
1.6.2.5

