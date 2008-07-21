Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:60131 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbYGUH5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 03:57:49 -0400
Date: Mon, 21 Jul 2008 09:57:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Larry.Finger@lwfinger.net, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org, jgarzik@pobox.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] drivers/net/wireless/b43legacy/main.c: Release mutex in
 error handling code
Message-ID: <Pine.LNX.4.64.0807210957270.24625@ask.diku.dk> (sfid-20080721_095827_121251_FE304C9E)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

---
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
 
