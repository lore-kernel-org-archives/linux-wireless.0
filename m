Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46856 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZHLQ5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:57:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:57:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath5k: use bit shift operators for cache line size
Date: Wed, 12 Aug 2009 09:57:01 -0700
Message-ID: <1250096221-11000-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This matches ath9k, providing consistency when reading both drivers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 63c2b57..2b3cf39 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -471,7 +471,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		 * DMA to work so force a reasonable value here if it
 		 * comes up zero.
 		 */
-		csz = L1_CACHE_BYTES / sizeof(u32);
+		csz = L1_CACHE_BYTES >> 2;
 		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
 	}
 	/*
@@ -544,7 +544,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	__set_bit(ATH_STAT_INVALID, sc->status);
 
 	sc->iobase = mem; /* So we can unmap it on detach */
-	sc->common.cachelsz = csz * sizeof(u32); /* convert to bytes */
+	sc->common.cachelsz = csz << 2; /* convert to bytes */
 	sc->opmode = NL80211_IFTYPE_STATION;
 	sc->bintval = 1000;
 	mutex_init(&sc->lock);
-- 
1.6.3.3

