Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbXLWVFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:05:30 -0500
Subject: [PATCH] mac80211: make rc_pid_fop_events static
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 22:05:25 +0100
Message-Id: <1198443925.4487.5.camel@johannes.berg> (sfid-20071223_210536_832279_6AF4D675)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to not be.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rc80211_pid_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/rc80211_pid_debugfs.c	2007-12-23 22:02:37.659083062 +0100
+++ everything/net/mac80211/rc80211_pid_debugfs.c	2007-12-23 22:02:40.109086697 +0100
@@ -197,7 +197,7 @@ static ssize_t rate_control_pid_events_r
 
 #undef RC_PID_PRINT_BUF_SIZE
 
-struct file_operations rc_pid_fop_events = {
+static struct file_operations rc_pid_fop_events = {
 	.owner = THIS_MODULE,
 	.read = rate_control_pid_events_read,
 	.poll = rate_control_pid_events_poll,


