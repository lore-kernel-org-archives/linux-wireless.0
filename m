Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48324 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbYAZDDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 22:03:39 -0500
Date: Sat, 26 Jan 2008 04:02:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 1/2] rc80211-pid: fix adjusted index check
Message-ID: <20080126040217.7c5d2928@morte> (sfid-20080126_030351_627577_BBE8C6B4)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compare adjusted indices with real mac80211 indices instead of internal ones
while checking them.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John, not sure if this fixes the bug Larry reported, but should applied
anyway.

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -78,8 +78,13 @@ static int rate_control_pid_shift_adjust
 	i = j + adj;
 
 	if (i < 0)
+		i = r[0].rev_index;
+	if (i > l - 1)
+		i = r[l - 1].rev_index;
+
+	if (r[i].index <= 0)
 		return r[0].index;
-	if (i >= l - 1)
+	if (r[i].index >= l - 1)
 		return r[l - 1].index;
 
 	tmp = i;


-- 
Ciao
Stefano
