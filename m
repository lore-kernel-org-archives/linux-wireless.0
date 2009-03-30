Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25183 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704AbZC3KCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:52 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38866.677695.877823@gargle.gargle.HOWL> (sfid-20090330_120258_667521_4E56FC4D)
Date: Mon, 30 Mar 2009 15:28:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 10/17] ath9k: Check for root debugfs file
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Creation of the root debugfs file could have failed
for some reason, check properly before proceeding in this
case.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index fdf9528..97df20c 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -498,6 +498,9 @@ int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->debug.debug_mask = ath9k_debug;
 
+	if (!ath9k_debugfs_root)
+		return -ENOENT;
+
 	sc->debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
 						      ath9k_debugfs_root);
 	if (!sc->debug.debugfs_phy)
-- 
1.6.2.1

