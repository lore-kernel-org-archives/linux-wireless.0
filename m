Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59055 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZALUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] =?utf-8?q?p54:=20fix=20"=E2=80=98ret=E2=80=99=20may=20be=20used=20uninitialized"=20warning?=
Date: Mon, 12 Jan 2009 14:49:01 -0500
Message-Id: <1231789741-13433-5-git-send-email-linville@tuxdriver.com> (sfid-20090112_210108_518682_138E430A)
In-Reply-To: <1231789741-13433-4-git-send-email-linville@tuxdriver.com>
References: <>
 <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
 <1231789741-13433-4-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_config=E2=
=80=99:
drivers/net/wireless/p54/p54common.c:1853: warning: =E2=80=98ret=E2=80=99=
 may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54/p54common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireles=
s/p54/p54common.c
index cba89ed..c6a370f 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1850,7 +1850,7 @@ static void p54_remove_interface(struct ieee80211=
_hw *dev,
=20
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
 {
-	int ret;
+	int ret =3D 0;
 	struct p54_common *priv =3D dev->priv;
 	struct ieee80211_conf *conf =3D &dev->conf;
=20
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
