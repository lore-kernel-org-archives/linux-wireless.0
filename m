Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40036 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JOV47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 17:56:59 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Properly initialize ath_common->cc_lock.
Date: Fri, 15 Oct 2010 14:56:53 -0700
Message-Id: <1287179813-18427-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, lockdep splats, at the least.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 a4c5ed4... fdc25f9... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4c5ed4..fdc25f9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -577,6 +577,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->hw = sc->hw;
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
+	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
-- 
1.7.2.2

