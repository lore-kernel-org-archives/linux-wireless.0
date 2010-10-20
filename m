Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14866 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0JTXHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH 6/6] ath9k: add a debug warning when we cannot stop RX
Date: Wed, 20 Oct 2010 16:07:08 -0700
Message-ID: <1287616028-12547-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have seen several DMA races when we race against
stopping and starting the PCU. I suspect that when
we cannot stop the PCU we may hit some of these same
races so warn against them for now but only when
debugging (CONFIG_ATH_DEBUG) is enabled.

If you run into this warning and are a developer,
please fix the cause of the warning. The potential
here, although I cannot prove yet, is that the DMA
engine can be confused and start writing to a buffer
that was already DMA'd before and at least the kernel
assumes is not being accessed by hardware anymore.

Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c04a940..87fabf8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -528,6 +528,8 @@ bool ath_stoprecv(struct ath_softc *sc)
 		sc->rx.rxlink = NULL;
 	spin_unlock_bh(&sc->rx.rxbuflock);
 
+	ATH_DBG_WARN(!stopped, "Could not stop RX, we could be "
+		     "confusing the DMA engine when we start RX up\n");
 	return stopped;
 }
 
-- 
1.7.0.4

