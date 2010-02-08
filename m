Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:50367 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0BHC6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 21:58:49 -0500
Date: Sun, 7 Feb 2010 21:48:37 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Subject: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
 algorithm
Message-ID: <20100207214837.027dfd3d@mycelium.queued.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I discovered that if EMBEDDED=y, one can accidentally build a mac80211 stack
w/ no rate control algorithm.  When RC_MINISTREL and RC_PID are both disabled,
the RC_DEFAULT string (which rate.c uses as the fallback algorithm) will be
"".  That'll cause the rate_control_alloc to fail, which will in turn cause
ieee80211_register_hw to fail.  IOW, no driver will load.

This will tell kconfig to provide a warning if no rate control algorithms
have been selected.  That'll at least warn the user that they're about to
build a broken wireless stack.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 net/mac80211/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a10d508..1f0ebab 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -15,8 +15,12 @@ comment "CFG80211 needs to be enabled for MAC80211"
 
 if MAC80211 != n
 
+config MAC80211_HAS_RC
+	def_bool n
+
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EMBEDDED
+	select MAC80211_HAS_RC
 	---help---
 	  This option enables a TX rate control algorithm for
 	  mac80211 that uses a PID controller to select the TX
@@ -24,12 +28,14 @@ config MAC80211_RC_PID
 
 config MAC80211_RC_MINSTREL
 	bool "Minstrel" if EMBEDDED
+	select MAC80211_HAS_RC
 	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 choice
 	prompt "Default rate control algorithm"
+	depends on MAC80211_HAS_RC
 	default MAC80211_RC_DEFAULT_MINSTREL
 	---help---
 	  This option selects the default rate control algorithm
@@ -62,6 +68,9 @@ config MAC80211_RC_DEFAULT
 
 endif
 
+comment "mac80211 will not work properly w/out rate control algorithm"
+	depends on MAC80211_HAS_RC=n
+
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
-- 
1.5.6.5

