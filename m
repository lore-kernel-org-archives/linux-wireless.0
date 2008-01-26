Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42950 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYAZDGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 22:06:51 -0500
Date: Sat, 26 Jan 2008 04:05:34 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 2/2] rc80211-pid: add sanity check
Message-ID: <20080126040534.005e6736@morte> (sfid-20080126_030654_593991_3E33954A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <larry.finger@lwfinger.net>

Add a sanity check in rate_control_pid_adjust_rate(). Thanks to Larry Finger
for suggesting this and reporting a related bug.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
NOT-Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---
Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -128,6 +128,11 @@ static void rate_control_pid_adjust_rate
 		}
 
 		newidx += back;
+
+		if (newidx < 0 || newidx >= sband->n_bitrates) {
+			WARN_ON(1);
+			break;
+		}
 	}
 
 #ifdef CONFIG_MAC80211_DEBUGFS


-- 
Ciao
Stefano
