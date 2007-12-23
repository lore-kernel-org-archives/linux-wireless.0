Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:60783 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157AbXLWDmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:42:23 -0500
Date: Sun, 23 Dec 2007 04:40:32 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 2/7] rc80211-pid: add kerneldoc for tunable parameters
Message-ID: <20071223044032.4ccece3e@morte> (sfid-20071223_034230_825458_E8C5DDE9)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a kerneldoc description for parameters which are tunable through debugfs.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 rc80211_pid.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: wireless-2.6/net/mac80211/rc80211_pid.h
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.h
+++ wireless-2.6/net/mac80211/rc80211_pid.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -119,6 +120,29 @@ struct rc_pid_events_file_info {
 	unsigned int next_entry;
 };

+/**
+ * struct rc_pid_debugfs_entries - tunable parameters
+ *
+ * Algorithm parameters, tunable via debugfs.
+ * @dir: the debugfs directory for a specific phy
+ * @target: target percentage for failed frames
+ * @sampling_period: error sampling interval in milliseconds
+ * @coeff_p: absolute value of the proportional coefficient
+ * @coeff_i: absolute value of the integral coefficient
+ * @coeff_d: absolute value of the derivative coefficient
+ * @smoothing_shift: absolute value of the integral smoothing factor (i.e.
+ *	amount of smoothing introduced by the exponential moving average)
+ * @sharpen_factor: absolute value of the derivative sharpening factor (i.e.
+ *	amount of emphasis given to the derivative term after low activity
+ *	events)
+ * @sharpen_duration: duration of the sharpening effect after the detected low
+ *	activity event, relative to sampling_period
+ * @norm_offset: amount of normalization periodically performed on the learnt
+ *	rate behaviour values (lower means we should trust more what we learnt
+ *	about behaviour of rates, higher means we should trust more the natural
+ *	ordering of rates)
+ * @fast_start: if Y, push high rates right after initialization
+ */
 struct rc_pid_debugfs_entries {
 	struct dentry *dir;
 	struct dentry *target;

-- 
Ciao
Stefano
