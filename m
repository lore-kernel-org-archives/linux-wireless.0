Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38310 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753226AbZAYMly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 07:41:54 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 25 Jan 2009 13:41:51 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090125124151.115210@gmx.net> (sfid-20090125_134208_568506_FF144245)
MIME-Version: 1.0
Subject: [PATCH] b43: Accessing the TSF via mac80211
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the mac80211 high level code to access the TSF. This is e.g=
=2E needed for BSSID merges in the IBSS mode.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/drivers/net/wireless/b43/main.c wireles=
s-testing/drivers/net/wireless/b43/main.c
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 06=
:12:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 13:09:3=
5.000000000 +0100
@@ -3177,6 +3177,25 @@
 	return 0;
 }
=20
+static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
+{
+	struct b43_wl *wl =3D hw_to_b43_wl(hw);
+	struct b43_wldev *dev =3D wl->current_dev;
+	u64 tsf;
+
+	b43_tsf_read(dev, &tsf);
+
+	return tsf;
+}
+
+static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+{
+	struct b43_wl *wl =3D hw_to_b43_wl(hw);
+	struct b43_wldev *dev =3D wl->current_dev;
+
+	b43_tsf_write(dev, tsf);
+}
+
 static void b43_put_phy_into_reset(struct b43_wldev *dev)
 {
 	struct ssb_device *sdev =3D dev->dev;
@@ -4296,6 +4315,8 @@
 	.set_key		=3D b43_op_set_key,
 	.get_stats		=3D b43_op_get_stats,
 	.get_tx_stats		=3D b43_op_get_tx_stats,
+	.get_tsf		=3D b43_op_get_tsf,
+	.set_tsf		=3D b43_op_set_tsf,
 	.start			=3D b43_op_start,
 	.stop			=3D b43_op_stop,
 	.set_tim		=3D b43_op_beacon_set_tim,

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
