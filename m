Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2HCKtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 06:49:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] rt61pci: fix NULL pointer dereference in config_lna_gain
Date: Fri,  3 Aug 2012 12:49:14 +0200
Message-Id: <1343990954-4285-1-git-send-email-sgruszka@redhat.com> (sfid-20120803_125013_320446_64D4B833)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can not pass NULL libconf->conf->channel to rt61pci_config() as it
is dereferenced unconditionally in rt61pci_config_lna_gain() subroutine.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=44361

Cc: stable@vger.kernel.org
Reported-and-tested-by: <dolohow@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ee22bd7..5fb3a2e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2243,8 +2243,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 
 static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 {
-	struct ieee80211_conf conf = { .flags = 0 };
-	struct rt2x00lib_conf libconf = { .conf = &conf };
+	struct rt2x00lib_conf libconf = { .conf = &rt2x00dev->hw->conf };
 
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
-- 
1.7.1

