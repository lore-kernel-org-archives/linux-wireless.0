Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59057 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240AbZALUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] =?utf-8?q?b43:=20fix=20"=E2=80=98gmode=E2=80=99=20may=20be=20used=20uninitialized"=20warning?=
Date: Mon, 12 Jan 2009 14:48:58 -0500
Message-Id: <1231789741-13433-2-git-send-email-linville@tuxdriver.com> (sfid-20090112_210112_375432_87FD8954)
In-Reply-To: <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
References: <>
 <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_config=E2=80=
=99:
drivers/net/wireless/b43/main.c:3264: warning: =E2=80=98gmode=E2=80=99 =
may be used uninitialized

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43=
/main.c
index 7b31a32..c788bad 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3261,7 +3261,7 @@ static int b43_switch_band(struct b43_wl *wl, str=
uct ieee80211_channel *chan)
 	struct b43_wldev *down_dev;
 	struct b43_wldev *d;
 	int err;
-	bool gmode;
+	bool uninitialized_var(gmode);
 	int prev_status;
=20
 	/* Find a device and PHY which supports the band. */
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
