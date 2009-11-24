Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gundega.hpl.hp.com ([192.6.19.190]:54606 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964AbZKXS7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 13:59:34 -0500
Date: Tue, 24 Nov 2009 10:47:08 -0800
From: Jean Tourrilhes <jt@hpl.hp.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] WE: Fix set events not propagated
Message-ID: <20091124184708.GA30638@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

	I've just noticed that some events are no longer propagated
for some wireless drivers. Basically, SET request with a extra payload
for driver without commit handler. The fix is pretty simple, see
attached.
	Actually, a few lines below this line, you will see that the
event generation for simple SET (iwpoint-less ?) is done properly,
and this other event generation does not need fixing.
	Regards,

	Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

diff -u -p linux/net/wireless/wext.j1.c linux/net/wireless/wext.c
--- linux/net/wireless/wext.j1.c	2009-11-23 17:42:24.000000000 -0800
+++ linux/net/wireless/wext.c	2009-11-23 17:44:41.000000000 -0800
@@ -809,7 +809,8 @@ static int ioctl_standard_iw_point(struc
 	}
 
 	/* Generate an event to notify listeners of the change */
-	if ((descr->flags & IW_DESCR_FLAG_EVENT) && err == -EIWCOMMIT) {
+	if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
+	    ((err == 0) || (err == -EIWCOMMIT))) {
 		union iwreq_data *data = (union iwreq_data *) iwp;
 
 		if (descr->flags & IW_DESCR_FLAG_RESTRICT)


