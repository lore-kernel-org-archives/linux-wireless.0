Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52616 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752839AbXLTXMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 18:12:05 -0500
Date: Fri, 21 Dec 2007 00:02:55 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] rc80211-pid: fix debugfs missing symbols
Message-ID: <20071221000255.5887a71c@morte> (sfid-20071220_231218_029095_6D2203B4)
In-Reply-To: <200712202035.45909.mb@bu3sch.de>
References: <200712202020.51320.mb@bu3sch.de>
	<200712202035.45909.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare the module license, so that debugfs will happily export its
symbols to us.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -12,12 +12,17 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
+#include <linux/debugfs.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"
 
 #include "rc80211_pid.h"
 
+MODULE_DESCRIPTION("PID controller based rate control algorithm");
+MODULE_AUTHOR("Stefano Brivio");
+MODULE_AUTHOR("Mattias Nissler");
+MODULE_LICENSE("GPL");
 
 /* This is an implementation of a TX rate control algorithm that uses a PID
  * controller. Given a target failed frames rate, the controller decides about
Index: wireless-2.6/net/mac80211/rc80211_pid_debugfs.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_debugfs.c
+++ wireless-2.6/net/mac80211/rc80211_pid_debugfs.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
+#include <linux/debugfs.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"



-- 
Ciao
Stefano
