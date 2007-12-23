Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:39988 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754165AbXLWDlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:41:10 -0500
Date: Sun, 23 Dec 2007 04:39:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 1/7] rc80211-pid: export human-readable target_pf value to
 debugfs
Message-ID: <20071223043917.7ec437e9@morte> (sfid-20071223_034113_985251_517DFDE1)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the non-shifted target_pf value to debugfs, so that it's human-readable.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 rc80211_pid.h      |    2 +-
 rc80211_pid_algo.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: wireless-2.6/net/mac80211/rc80211_pid.h
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.h
+++ wireless-2.6/net/mac80211/rc80211_pid.h
@@ -38,7 +38,7 @@
  * link quality is good, the controller will fail to adjust failed frames
  * percentage to the target. This is intentional.
  */
-#define RC_PID_TARGET_PF (11 << RC_PID_ARITH_SHIFT)
+#define RC_PID_TARGET_PF 11

 /* Rate behaviour normalization quantity over time. */
 #define RC_PID_NORM_OFFSET 3
Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -210,7 +210,7 @@ static void rate_control_pid_sample(stru
 	rate_control_pid_normalize(pinfo, mode->num_rates);

 	/* Compute the proportional, integral and derivative errors. */
-	err_prop = pinfo->target - pf;
+	err_prop = (pinfo->target << RC_PID_ARITH_SHIFT) - pf;

 	err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;

-- 
Ciao
Stefano
