Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30882 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2AYISZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 03:18:25 -0500
Date: Wed, 25 Jan 2012 11:18:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: re: b43: N-PHY: implement RSSI calibration for rev3+
Message-ID: <20120125081815.GA19911@elgon.mountain> (sfid-20120125_091830_134310_16C13896)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rafał Miłecki,

The patch e0c9a0219a8f: "b43: N-PHY: implement RSSI calibration for 
rev3+" from Jan 5, 2012, leads to the following Smatch warning:
drivers/net/wireless/b43/phy_n.c +1381 b43_nphy_rev3_rssi_cal()
	 error: buffer overflow 'results[j]' 4 <= 4


+               for (i = 0; i < 4; i++) {
+                       s32 curr;
+                       s32 mind = 40;
+                       s32 minpoll = 249;
+                       u8 minvcm = 0;
+                       if (2 * core != i)
+                               continue;
+                       for (j = 0; j < 8; j++) {
+                               curr = results[j][i] * results[j][i] +
+                                       results[j][i + 1] * results[j][i];
                                                   ^^^^^
On the last iteration through the loop "i + 1" = 4.

+                               if (curr < mind) {
+                                       mind = curr;
+                                       minvcm = j;
+                               }
+                               if (results[j][i] < minpoll)
+                                       minpoll = results[j][i];
+                       }
+                       vcm_final = minvcm;
+                       results_min[i] = minpoll;
+               }

I don't know the code well enough to say if this can happen or not.
Perhaps on the last iteration we always hit the "if (2 * core != i)
continue" condition.  Anyway, since this is the first time this has hit
linux-next, I thought I would let you know.

regards,
dan carpenter

