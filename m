Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0FUJAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 05:00:44 -0400
Received: by bwz7 with SMTP id 7so837308bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 02:00:42 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: allow selection of minstrel_ht as default rc algo
Date: Mon, 21 Jun 2010 10:59:56 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006211059.58879.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow selection of minstrel_ht as default rate control algorithm. At the
moment minstrel_ht can only be requested by the driver code but not selected
as default in make menuconfig.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 83eec7a..3ad82cd 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -64,6 +64,11 @@ config MAC80211_RC_DEFAULT_MINSTREL
 	---help---
 	  Select Minstrel as the default rate control algorithm.
 
+config MAC80211_RC_DEFAULT_MINSTREL_HT
+	bool "Minstrel HT"
+	depends on MAC80211_RC_MINSTREL_HT
+	---help---
+	  Select Minstrel HT as the default rate control algorithm.
 
 endchoice
 
@@ -71,6 +76,7 @@ config MAC80211_RC_DEFAULT
 	string
 	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
 	default "pid" if MAC80211_RC_DEFAULT_PID
+	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL_HT
 	default ""
 
 endif
-- 
1.6.4.2

