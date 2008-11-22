Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:45824 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYKVDW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 22:22:57 -0500
Received: by ti-out-0910.google.com with SMTP id b6so749293tic.23
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 19:22:55 -0800 (PST)
From: crquan@gmail.com
To: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath5k: fix Security issue in DebugFS part of ath5k
Date: Sat, 22 Nov 2008 11:22:49 +0800
Message-Id: <1227324169-13260-1-git-send-email-crquan@gmail.com> (sfid-20081122_042310_877621_B5933101)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Cheng Renquan <crquan@gmail.com>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12076

Remove any write access to groups and others, only keep write permissio=
n
to its owner, usually only root user.

Reported-by: J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com>
Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/net/wireless/ath5k/debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/=
ath5k/debug.c
index 19980cb..ccaeb5c 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -417,19 +417,19 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 	sc->debug.debugfs_phydir =3D debugfs_create_dir(wiphy_name(sc->hw->wi=
phy),
 				ath5k_global_debugfs);
=20
-	sc->debug.debugfs_debug =3D debugfs_create_file("debug", 0666,
+	sc->debug.debugfs_debug =3D debugfs_create_file("debug", S_IWUSR | S_=
IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_debug);
=20
-	sc->debug.debugfs_registers =3D debugfs_create_file("registers", 0444=
,
+	sc->debug.debugfs_registers =3D debugfs_create_file("registers", S_IR=
UGO,
 				sc->debug.debugfs_phydir, sc, &fops_registers);
=20
-	sc->debug.debugfs_tsf =3D debugfs_create_file("tsf", 0666,
+	sc->debug.debugfs_tsf =3D debugfs_create_file("tsf", S_IWUSR | S_IRUG=
O,
 				sc->debug.debugfs_phydir, sc, &fops_tsf);
=20
-	sc->debug.debugfs_beacon =3D debugfs_create_file("beacon", 0666,
+	sc->debug.debugfs_beacon =3D debugfs_create_file("beacon", S_IWUSR | =
S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
=20
-	sc->debug.debugfs_reset =3D debugfs_create_file("reset", 0222,
+	sc->debug.debugfs_reset =3D debugfs_create_file("reset", S_IWUSR,
 				sc->debug.debugfs_phydir, sc, &fops_reset);
 }
=20
--=20
1.6.0.4.758.g36c05

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
