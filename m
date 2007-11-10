Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51874
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXKJPOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 10:14:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: silence a bogus gcc warning
Date: Sat, 10 Nov 2007 16:14:03 +0100
Cc: Frank Lichtenheld <frank@lichtenheld.de>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Message-Id: <200711101614.03776.mb@bu3sch.de> (sfid-20071110_151500_362296_FD42EDFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Frank Lichtenheld <frank@lichtenheld.de>

inititalise ret to 0 to avoid the following bogus warning:
  CC [M]  drivers/net/wireless/b43/debugfs.o
drivers/net/wireless/b43/debugfs.c: In function =E2=80=98b43_debugfs_re=
ad=E2=80=99:
drivers/net/wireless/b43/debugfs.c:355: warning: =E2=80=98ret=E2=80=99 =
may be used uninitialized in this function

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

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



-------------------------------------------------------

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
