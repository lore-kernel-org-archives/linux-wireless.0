Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751AbZANAUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 19:20:34 -0500
Date: Tue, 13 Jan 2009 18:20:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Eliminate compilation warning in b43_op_set_key
Message-ID: <496d2fc9.UiHMYJR2melvWyoO%Larry.Finger@lwfinger.net> (sfid-20090114_012049_165936_855BDE57)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent pull from wireless testing generates the following warning:
=20
   CC [M]  drivers/net/wireless/b43/main.o
 drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_key=E2=
=80=99:
 drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatch
 in conditional expression

This fix was suggested by Johannes Berg <johannes@sipsolutions.net>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -3630,10 +3630,12 @@ static int b43_op_set_key(struct ieee802
=20
 out_unlock:
 	if (!err) {
+		u8 bcast[ETH_ALEN];
+		memset(bcast, 0xff, ETH_ALEN);
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %pM\n",
 		       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->keyidx,
-		       sta ? sta->addr : "<group key>");
+		       sta ? sta->addr : bcast);
 		b43_dump_keymemory(dev);
 	}
 	write_unlock(&wl->tx_lock);
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
