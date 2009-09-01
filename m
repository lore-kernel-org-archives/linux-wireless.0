Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10867 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbZIAPWz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 7/7] wireless: remove mac80211 rate selection extra menu
Date: Tue, 1 Sep 2009 08:22:46 -0700
Message-ID: <1251818566-9264-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
1.6.3.3

