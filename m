Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:38190 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3BPTXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 14:23:42 -0500
Received: by mail-da0-f48.google.com with SMTP id v40so1904679dad.21
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2013 11:23:41 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
Date: Sat, 16 Feb 2013 11:22:31 -0800
Message-Id: <1361042551-15598-1-git-send-email-thomas@cozybit.com> (sfid-20130216_202348_362591_A9A7664F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increases mac80211 memory use by about 95K.

At least Ubuntu, Debian, and Arch Linux already enable
this in their default kernels.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/Kconfig |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 0ecf947..4ca2a49 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -80,14 +80,15 @@ comment "Some wireless drivers require a rate control algorithm"
 	depends on MAC80211 && MAC80211_HAS_RC=n
 
 config MAC80211_MESH
-	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-	depends on MAC80211 && EXPERIMENTAL
+	bool "Enable mac80211 mesh networking (802.11s) support"
+	depends on MAC80211
+	default y
 	---help---
-	 This options enables support of Draft 802.11s mesh networking.
-	 The implementation is based on Draft 2.08 of the Mesh Networking
-	 amendment.  However, no compliance with that draft is claimed or even
-	 possible, as drafts leave a number of identifiers to be defined after
-	 ratification.  For more information visit http://o11s.org/.
+	 This options enables support for 802.11s mesh networking.  The
+	 implementation is based on the 11s amendment introduced in IEEE
+	 802.11-2012. An effort has been made to be standard-compliant, so If
+	 you notice something amiss, please contact the maintainers.  For more
+	 information visit http://o11s.org/.
 
 config MAC80211_LEDS
 	bool "Enable LED triggers"
-- 
1.7.10.4

