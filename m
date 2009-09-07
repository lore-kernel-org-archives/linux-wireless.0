Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64532 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbZIGMZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 08:25:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 05:25:24 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Remove unnecessary casting to u8 in pci_read_config_byte() call
Date: Mon, 7 Sep 2009 17:46:50 +0530
Message-ID: <1252325810-6159-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1252325810-6159-1-git-send-email-vasanth@atheros.com>
References: <1252325810-6159-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 8bb286d..8b28814 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -35,8 +35,7 @@ static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	u8 u8tmp;
 
-	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE,
-			     (u8 *)&u8tmp);
+	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE, &u8tmp);
 	*csz = (int)u8tmp;
 
 	/*
-- 
1.5.5.1

