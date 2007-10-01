Return-path: <linux-wireless-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Received: from gepetto.dc.ltu.se ([130.240.42.40]:43224 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXJAAZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 20:25:18 -0400
Date: Mon, 1 Oct 2007 02:24:38 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071001002440.15772.83520.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] softmac: Fix compiler-warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC      net/ieee80211/softmac/ieee80211softmac_wx.o
/home/kernel/src/net/ieee80211/softmac/ieee80211softmac_wx.c: In functi=
on =E2=80=98ieee80211softmac_wx_set_essid=E2=80=99:
/home/kernel/src/net/ieee80211/softmac/ieee80211softmac_wx.c:117: warni=
ng: label =E2=80=98out=E2=80=99 defined but not used

due to commit: efe870f9f4ad74410a18ecbf0d9ba7c14b50a0fb. Removing the l=
abel.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested


diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee8021=
1/softmac/ieee80211softmac_wx.c
index 442b987..5742dc8 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -114,7 +114,7 @@ check_assoc_again:
 	sm->associnfo.associating =3D 1;
 	/* queue lower level code to do work (if necessary) */
 	schedule_delayed_work(&sm->associnfo.work, 0);
-out:
+
 	mutex_unlock(&sm->associnfo.mutex);
=20
 	return 0;
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
