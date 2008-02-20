Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYBTSbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:31:15 -0500
Subject: [PATCH] mac80211: check endianness/types in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 11:38:29 +0100
Message-Id: <1203503909.17534.14.camel@johannes.berg> (sfid-20080220_183118_064616_3A6DF178)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure sparse checks endianness when run on mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sam, is this an OK use of makefiles or is there something else I should
be doing?

The only warnings this currently triggers are some signedness warnings
in the PID RC algorithm.

 net/mac80211/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- everything.orig/net/mac80211/Makefile	2008-02-19 18:35:28.151573893 +0100
+++ everything/net/mac80211/Makefile	2008-02-19 18:41:10.491563910 +0100
@@ -45,3 +45,5 @@ mac80211-$(CONFIG_MAC80211_RC_PID) += $(
 
 # Modular rate algorithms are assigned to mac80211-m - make separate modules
 obj-m += $(mac80211-m)
+
+CHECKFLAGS += -D__CHECK_ENDIAN__


