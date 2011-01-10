Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58475 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1AJHMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:07 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 02/11] ath9k:  Initialize ah->hw
Date: Sun,  9 Jan 2011 23:11:44 -0800
Message-Id: <1294643513-18820-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Previous code left it NULL.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 767d8b8... 23b2998... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 767d8b8..23b2998 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -537,6 +537,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (!ah)
 		return -ENOMEM;
 
+	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
-- 
1.7.2.3

