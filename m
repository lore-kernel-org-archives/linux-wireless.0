Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:37237 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab0BPVRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:17:16 -0500
Date: Tue, 16 Feb 2010 16:16:56 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: give warning if building w/out rate ctrl
 algorithm
Message-ID: <20100216161656.42079d77@droptest.queued.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I discovered that if EMBEDDED=y, one can accidentally build a mac80211 stack
and drivers w/ no rate control algorithm.  For drivers like RTL8187 that don't
supply their own RC algorithms, this will cause ieee80211_register_hw to
fail (making the driver unusable).

This will tell kconfig to provide a warning if no rate control algorithms
have been selected.  That'll at least warn the user; users that know that
their drivers supply a rate control algorithm can safely ignore the
warning, and those who don't know (or who expect to be using multiple
drivers) can select a default RC algorithm.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: stable@kernel.org
---
 net/mac80211/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a10d508..2a51b0b 100644
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
 
+comment "some wireless drivers require a rate control algorithm"
+	depends on MAC80211_HAS_RC=n
+
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
-- 
1.5.6.5

