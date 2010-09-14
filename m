Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0INXkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	stable@kernel.org, Paul Stewart <pstew@google.com>,
	Sameer Nanda <snanda@google.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	Amod Bodas <amod.bodas@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 10/11] ath9k: fix regression which prevents chip sleep after CAB data
Date: Tue, 14 Sep 2010 19:40:23 -0400
Message-Id: <1284507624-18176-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

The patch:

commit 293dc5dfdbcc16cde06e40a688394cc8ab083e48
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Fri Jun 19 12:17:48 2009 +0200

    ath9k: remove ath_rx_ps_back_to_sleep helper

    This helper only clears the SC_OP_WAIT_FOR_{BEACON,CAB} flags.
    Remove it and clear these flags directly in the approptiate
    places instead.

    Changes-licensed-under: ISC
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

introduced a regression which forgot to lift the beacon flag
after we received all broadcast and multicast data. This meant
we never went to sleep consuming about ~650mW on idle. This pretty
much broke power save completely.

This patch has fixes for stable kernels [2.6.32+].

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Sameer Nanda <snanda@google.com>
Cc: Gabor Juhos <juhosg@openwrt.org>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index efd0651..dbd4b0c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -639,7 +639,7 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		 * No more broadcast/multicast frames to be received at this
 		 * point.
 		 */
-		sc->ps_flags &= ~PS_WAIT_FOR_CAB;
+		sc->ps_flags &= ~(PS_WAIT_FOR_CAB | PS_WAIT_FOR_BEACON);
 		ath_print(common, ATH_DBG_PS,
 			  "All PS CAB frames received, back to sleep\n");
 	} else if ((sc->ps_flags & PS_WAIT_FOR_PSPOLL_DATA) &&
-- 
1.7.0.4

