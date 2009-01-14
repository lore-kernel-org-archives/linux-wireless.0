Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762042AbZANRPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:15:32 -0500
Date: Wed, 14 Jan 2009 11:15:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Eliminate compilation warning in b43_op_set_key
Message-ID: <496e1dad.5mYJIKpzG2eoWa+t%Larry.Finger@lwfinger.net> (sfid-20090114_181536_703408_3E5A9549)
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
@@ -3535,6 +3535,9 @@ static int b43_op_set_key(struct ieee802
 	u8 algorithm;
 	u8 index;
 	int err;
+#if B43_DEBUG
+	static const u8 bcast_addr[ETH_ALEN] =3D {0xff, 0xff, 0xff, 0xff, 0xf=
f, 0xff};
+#endif
=20
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
@@ -3633,7 +3636,7 @@ out_unlock:
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %pM\n",
 		       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->keyidx,
-		       sta ? sta->addr : "<group key>");
+		       sta ? sta->addr : bcast_addr);
 		b43_dump_keymemory(dev);
 	}
 	write_unlock(&wl->tx_lock);
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
