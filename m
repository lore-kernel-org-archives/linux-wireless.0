Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v32413.1blu.de ([88.84.155.73]:40344 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXKIIdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:33:46 -0500
From: Frank Lichtenheld <frank@lichtenheld.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH][B43]: silence a bogus gcc warning
Date: Fri,  9 Nov 2007 09:13:50 +0100
Message-Id: <1194596030-23531-1-git-send-email-frank@lichtenheld.de> (sfid-20071109_083350_189497_57A14516)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

inititalise ret to 0 to avoid the following bogus warning:
  CC [M]  drivers/net/wireless/b43/debugfs.o
drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_debugfs_re=
ad=E2=80=99:
drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=80=99 =
may be used uninitialized in this function

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/net/wireless/b43/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/=
b43/debugfs.c
index 734e70e..d8ac058 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -352,7 +352,7 @@ static ssize_t b43_debugfs_read(struct file *file, =
char __user *userbuf,
 	struct b43_wldev *dev;
 	struct b43_debugfs_fops *dfops;
 	struct b43_dfs_file *dfile;
-	ssize_t ret;
+	ssize_t ret =3D 0;
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
