Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:58224 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbXLWDnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:43:16 -0500
Date: Sun, 23 Dec 2007 04:41:19 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 3/7] rc80211-pid: simplify and fix shift_adjust
Message-ID: <20071223044119.088f6b55@morte> (sfid-20071223_034320_049871_44B94797)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify and fix rate_control_pid_shift_adjust(). A bug prevented correct
mapping of sorted rates, and readability was seriously flawed.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 rc80211_pid_algo.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -74,29 +74,27 @@ static int rate_control_pid_shift_adjust
 {
 	int i, j, k, tmp;

-	if (cur + adj < 0)
-		return 0;
-	if (cur + adj >= l)
-		return l - 1;
+	j = r[cur].rev_index;
+	i = j + adj;

-	i = r[cur + adj].rev_index;
+	if (i < 0)
+		return r[0].index;
+	if (i >= l - 1)
+		return r[l - 1].index;

-	j = r[cur].rev_index;
+	tmp = i;

 	if (adj < 0) {
-			tmp = i;
-			for (k = j; k >= i; k--)
-				if (r[k].diff <= r[j].diff)
-					tmp = k;
-			return r[tmp].index;
-	} else if (adj > 0) {
-			tmp = i;
-			for (k = i + 1; k + i < l; k++)
-				if (r[k].diff <= r[i].diff)
-					tmp = k;
-			return r[tmp].index;
+		for (k = j; k >= i; k--)
+			if (r[k].diff <= r[j].diff)
+				tmp = k;
+	} else {
+		for (k = i + 1; k + i < l; k++)
+			if (r[k].diff <= r[i].diff)
+				tmp = k;
 	}
-	return cur + adj;
+
+	return r[tmp].index;
 }

 static void rate_control_pid_adjust_rate(struct ieee80211_local *local,

-- 
Ciao
Stefano
