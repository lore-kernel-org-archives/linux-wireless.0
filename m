Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([84.19.176.117]:42844 "EHLO ns.pmeerw.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbeFDUkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 16:40:52 -0400
From: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Subject: [PATCH] rfkill: Correctly document rkill subfolder range as >= 0 in sysfs-class-rfkill
Date: Mon,  4 Jun 2018 22:32:43 +0200
Message-Id: <20180604203243.28612-1-pmeerw@pmeerw.net> (sfid-20180604_224159_255728_05AEBC8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first subfolder is rfkill0, hence rfkillX (X >= 0).
Also fix two trivial typos.

Signed-off-by: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
---
 Documentation/ABI/stable/sysfs-class-rfkill | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index e1ba4a104753..80151a409d67 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -11,7 +11,7 @@ KernelVersion:	v2.6.22
 Contact:	linux-wireless@vger.kernel.org,
 Description: 	The rfkill class subsystem folder.
 		Each registered rfkill driver is represented by an rfkillX
-		subfolder (X being an integer > 0).
+		subfolder (X being an integer >= 0).
 
 
 What:		/sys/class/rfkill/rfkill[0-9]+/name
@@ -48,8 +48,8 @@ Contact:	linux-wireless@vger.kernel.org
 Description: 	Current state of the transmitter.
 		This file was scheduled to be removed in 2014, but due to its
 		large number of users it will be sticking around for a bit
-		longer. Despite it being marked as stabe, the newer "hard" and
-		"soft" interfaces should be preffered, since it is not possible
+		longer. Despite it being marked as stable, the newer "hard" and
+		"soft" interfaces should be preferred, since it is not possible
 		to express the 'soft and hard block' state of the rfkill driver
 		through this interface. There will likely be another attempt to
 		remove it in the future.
-- 
2.11.0
