Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v32413.1blu.de ([88.84.155.73]:47980 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbXKLKNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 05:13:00 -0500
From: Frank Lichtenheld <frank@lichtenheld.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Frank Lichtenheld <frank@lichtenheld.de>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] b43: silence a bogus gcc warning
Date: Mon, 12 Nov 2007 11:12:52 +0100
Message-Id: <1194862372-21289-1-git-send-email-frank@lichtenheld.de> (sfid-20071112_101309_075957_E1384070)
In-Reply-To: <20071110152533.GC32472@tuxdriver.com>
References: <20071110152533.GC32472@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use uninitialized_var() to avoid the following bogus warning:
  CC [M]  drivers/net/wireless/b43/debugfs.o
drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_debugfs_re=
ad=E2=80=99:
drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=80=99 =
may be used uninitialized in this function

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/net/wireless/b43/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 Changed to use uninitialized_var()

diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/=
b43/debugfs.c
index ef0075d..f84d063 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -352,7 +352,7 @@ static ssize_t b43_debugfs_read(struct file *file, =
char __user *userbuf,
 	struct b43_wldev *dev;
 	struct b43_debugfs_fops *dfops;
 	struct b43_dfs_file *dfile;
-	ssize_t ret;
+	ssize_t uninitialized_var(ret);
 	char *buf;
 	const size_t bufsize =3D 1024 * 128;
 	const size_t buforder =3D get_order(bufsize);
--=20
1.5.3.4

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
