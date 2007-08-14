Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37083
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbXHNSOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:14:01 -0400
Message-Id: <20070814181215.971466000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:19 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 6/9] b43: debugfs tx_status, Fix endless loop inside of spinlock
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an endless loop inside of a spinlock.
This triggers if the tx_status file is read before a packet
has been transmitted.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/debugfs.c	2007-08-12 16:38:51.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/debugfs.c	2007-08-13 15:48:06.000000000 +0200
@@ -173,6 +173,10 @@ static ssize_t txstat_read_file(struct f
 		i = log->end + 1;
 		idx = 0;
 		while (1) {
+			if (log->end < 0) {
+				fappend("Nothing transmitted, yet\n");
+				break;
+			}
 			if (i == B43_NR_LOGGED_TXSTATUS)
 				i = 0;
 			stat = &(log->log[i]);

-- 

