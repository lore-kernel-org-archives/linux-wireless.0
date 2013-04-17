Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46143 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966071Ab3DQLri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 07:47:38 -0400
Received: by mail-wi0-f173.google.com with SMTP id c10so346677wiw.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 04:47:37 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: optimize minstrel_ewma
Date: Wed, 17 Apr 2013 13:43:22 +0200
Message-Id: <1366199002-10177-1-git-send-email-karl.beldan@gmail.com> (sfid-20130417_134742_859278_73D296D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Use powers of two in ewma of minstrel.
This changes :
- EWMA_DIV   from 100 to 2^7
- EWMA_LEVEL from 75 (/EWMA_DIV=100) to 2^6 + 2^5 (/EWMA_DIV=128)

Note that this changes EWMA_DIV - EWMA_LEVEL from 25 to 2^5 and keeps
EWMA_LEVEL / EWMA_DIV == 0.75.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
Here's a quick benchmark with gcc -O2 -std=c99: {

#ifndef ORIG
#define EWMA_LEVEL      75
#define EWMA_DIV       100
#else
#define EWMA_LEVEL      96
#define EWMA_DIV       128
#endif
static inline int minstrel_ewma(int old, int new, int weight)
{
	return (new * (EWMA_DIV - weight) + old * weight) / EWMA_DIV;
}
int main()
{
	volatile int a, b, c;
	for (int i = 0; i < 1 << 30; i++)
		c = minstrel_ewma(a, b, EWMA_LEVEL);
	return 0;
}

On an i5:
before: real    0m2.426s
after:  real    0m1.495s
1.495 / 2.426 = 0.6

On a mv-feroceon:
before: real    0m20.231s
after:  real    0m18.193s
18.193 / 20.231 = 0.9
}

 net/mac80211/rc80211_minstrel.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 8e5a222..f4301f4 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -9,7 +9,8 @@
 #ifndef __RC_MINSTREL_H
 #define __RC_MINSTREL_H
 
-#define EWMA_LEVEL	75	/* ewma weighting factor [%] */
+#define EWMA_LEVEL	96	/* ewma weighting factor [/EWMA_DIV] */
+#define EWMA_DIV	128
 #define SAMPLE_COLUMNS	10	/* number of columns in sample table */
 
 
@@ -27,7 +28,7 @@
 static inline int
 minstrel_ewma(int old, int new, int weight)
 {
-	return (new * (100 - weight) + old * weight) / 100;
+	return (new * (EWMA_DIV - weight) + old * weight) / EWMA_DIV;
 }
 
 
-- 
1.8.2

