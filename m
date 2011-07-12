Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58702 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1GLBCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 21:02:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v3 4/8] ath5k: initialize common->clockrate
Date: Tue, 12 Jul 2011 09:02:01 +0800
Message-Id: <1310432525-70077-4-git-send-email-nbd@openwrt.org> (sfid-20110712_030225_634974_EB03CFC9)
In-Reply-To: <1310432525-70077-3-git-send-email-nbd@openwrt.org>
References: <1310432525-70077-1-git-send-email-nbd@openwrt.org>
 <1310432525-70077-2-git-send-email-nbd@openwrt.org>
 <1310432525-70077-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a division by zero when setting distance before activating the
device for the first time.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3e5e9b7..523bb08 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2420,6 +2420,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	common->ah = sc->ah;
 	common->hw = hw;
 	common->priv = sc;
+	common->clockrate = 40;
 
 	/*
 	 * Cache line size is used to size and align various
-- 
1.7.3.2

