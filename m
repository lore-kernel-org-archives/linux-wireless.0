Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56717 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZAXVio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 16:38:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix phy_g.c compiler warning
Date: Sat, 24 Jan 2009 22:36:57 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901242236.58641.mb@bu3sch.de> (sfid-20090124_223850_385119_3B094106)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46ix compile warning for non-debug builds:

drivers/net/wireless/b43/phy_g.c: In function =E2=80=98b43_gphy_op_reca=
lc_txpower=E2=80=99:
drivers/net/wireless/b43/phy_g.c:3195: warning: unused variable =E2=80=98=
dbm=E2=80=99

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2009-01-23 1=
9:18:42.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2009-01-24 22:33:=
44.000000000 +0100
@@ -3188,20 +3188,23 @@ static enum b43_txpwr_result b43_gphy_op
 	/* Lower attenuation =3D> Bigger power output. Negate it. */
 	bbatt_delta =3D -bbatt_delta;
 	/* RF att affects power level 4 times as much as
 	 * Baseband attennuation. Subtract it. */
 	bbatt_delta -=3D 4 * rfatt_delta;
=20
+#if B43_DEBUG
 	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
 		int dbm =3D pwr_adjust < 0 ? -pwr_adjust : pwr_adjust;
 		b43dbg(dev->wl,
 		       "[TX power deltas]  %s" Q52_FMT " dBm   =3D>   "
 		       "bbatt-delta =3D %d,  rfatt-delta =3D %d\n",
 		       (pwr_adjust < 0 ? "-" : ""), Q52_ARG(dbm),
 		       bbatt_delta, rfatt_delta);
 	}
+#endif /* DEBUG */
+
 	/* So do we finally need to adjust something in hardware? */
 	if ((rfatt_delta =3D=3D 0) && (bbatt_delta =3D=3D 0))
 		goto no_adjustment_needed;
=20
 	/* Save the deltas for later when we adjust the power. */
 	gphy->bbatt_delta =3D bbatt_delta;


--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
