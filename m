Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:63476 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289AbXITSJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 14:09:29 -0400
Date: Thu, 20 Sep 2007 11:08:18 -0700
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2.6.23] WE : Add missing auth compat-ioctl
Message-ID: <20070920180818.GA10711@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

	Johannes just found that we are missing a compat-ioctl
declaration. The fix is trivial. As previous patches for compat-ioctl,
this should also go to stable.
        More info :
                http://marc.info/?l=linux-wireless&m=119029667902588&w=2
	Regards,

	Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

-----------------------------------------------------------

diff -u -p linux-2.6.23-rc7/fs/compat_ioctl.j1.c  linux-2.6.23-rc7/fs/compat_ioctl.c
--- linux-2.6.23-rc7/fs/compat_ioctl.j1.c	2007-09-20 10:37:12.000000000 -0700
+++ linux-2.6.23-rc7/fs/compat_ioctl.c	2007-09-20 10:48:06.000000000 -0700
@@ -3190,6 +3190,8 @@ COMPATIBLE_IOCTL(SIOCSIWRETRY)
 COMPATIBLE_IOCTL(SIOCGIWRETRY)
 COMPATIBLE_IOCTL(SIOCSIWPOWER)
 COMPATIBLE_IOCTL(SIOCGIWPOWER)
+COMPATIBLE_IOCTL(SIOCSIWAUTH)
+COMPATIBLE_IOCTL(SIOCGIWAUTH)
 /* hiddev */
 COMPATIBLE_IOCTL(HIDIOCGVERSION)
 COMPATIBLE_IOCTL(HIDIOCAPPLICATION)

