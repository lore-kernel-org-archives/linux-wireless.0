Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59060 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbZALUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] =?utf-8?q?b43legacy:=20fix=20"=E2=80=98up=5Fdev=E2=80=99=20may=20be=20used=20uninitialized"=20warning?=
Date: Mon, 12 Jan 2009 14:48:59 -0500
Message-Id: <1231789741-13433-3-git-send-email-linville@tuxdriver.com> (sfid-20090112_210112_613864_1C8E72FB)
In-Reply-To: <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
References: <>
 <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/b43legacy/main.c: In function =E2=80=98b43legacy_o=
p_dev_config=E2=80=99:
drivers/net/wireless/b43legacy/main.c:2468: warning: =E2=80=98up_dev=E2=
=80=99 may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43legacy/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wirele=
ss/b43legacy/main.c
index c1324e3..fb996c2 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2465,7 +2465,7 @@ static void b43legacy_put_phy_into_reset(struct b=
43legacy_wldev *dev)
 static int b43legacy_switch_phymode(struct b43legacy_wl *wl,
 				      unsigned int new_mode)
 {
-	struct b43legacy_wldev *up_dev;
+	struct b43legacy_wldev *uninitialized_var(up_dev);
 	struct b43legacy_wldev *down_dev;
 	int err;
 	bool gmode =3D 0;
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
