Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYBAMH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:07:57 -0500
Subject: [PATCH] mac80211 rate control: fix section mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 19:31:57 +0100
Message-Id: <1201804317.4149.34.camel@johannes.berg> (sfid-20080201_120801_735547_E3C35D9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the rate control algorithms are built-in, their exit
functions can be called from mac80211's init function so
they cannot be marked __exit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rc80211_pid_algo.c |    2 +-
 net/mac80211/rc80211_simple.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-01-31 19:20:14.932284778 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-01-31 19:20:37.912263836 +0100
@@ -544,7 +544,7 @@ int __init rc80211_pid_init(void)
 	return ieee80211_rate_control_register(&mac80211_rcpid);
 }
 
-void __exit rc80211_pid_exit(void)
+void rc80211_pid_exit(void)
 {
 	ieee80211_rate_control_unregister(&mac80211_rcpid);
 }
--- everything.orig/net/mac80211/rc80211_simple.c	2008-01-31 19:20:41.342267959 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-01-31 19:20:52.632267796 +0100
@@ -381,7 +381,7 @@ int __init rc80211_simple_init(void)
 	return ieee80211_rate_control_register(&mac80211_rcsimple);
 }
 
-void __exit rc80211_simple_exit(void)
+void rc80211_simple_exit(void)
 {
 	ieee80211_rate_control_unregister(&mac80211_rcsimple);
 }


