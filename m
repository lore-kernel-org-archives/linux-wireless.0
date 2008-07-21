Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51194 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYGUJaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 05:30:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Release mutex in error handling code
Date: Mon, 21 Jul 2008 11:29:34 +0200
Cc: Larry.Finger@lwfinger.net, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org, jgarzik@pobox.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Message-Id: <200807211129.34610.mb@bu3sch.de> (sfid-20080721_113023_533475_7CF035CF)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: stable <stable@kernel.org>

---

John, please apply this bugfix to the next bugfix release.

diff -u -p a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3862,10 +3862,10 @@ static int b43legacy_resume(struct ssb_d
 			goto out;
 		}
 	}
-	mutex_unlock(&wl->mutex);
 
 	b43legacydbg(wl, "Device resumed.\n");
 out:
+	mutex_unlock(&wl->mutex);
 	return err;
 }
 
-- 
Greetings Michael.
