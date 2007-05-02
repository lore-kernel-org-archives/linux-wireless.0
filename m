Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:51296 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993220AbXEBOXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:23:13 -0400
Date: Wed, 02 May 2007 09:22:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix for missing global (tcf_destroy_chain) in  build
Message-ID: <46389ebb.JZh37v8gJUSOn1+U%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If MAC80211 is selected in the configuration without also selecting NET_SCHED,
there is a missing global (tcf_destroy_chain) in the build.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/Kconfig
===================================================================
--- wireless-dev.orig/net/mac80211/Kconfig
+++ wireless-dev/net/mac80211/Kconfig
@@ -9,6 +9,7 @@ config MAC80211
 	select WIRELESS_EXT
 	select CFG80211
 	select NET_SCH_FIFO
+	select NET_SCHED
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.

---

