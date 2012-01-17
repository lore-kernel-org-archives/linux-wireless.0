Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:57258 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2AQNFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:05:30 -0500
Subject: [PATCH 1/3] ath6kl: use netdev_features_t
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 15:05:19 +0200
Message-ID: <20120117130519.22832.29908.stgit@localhost6.localdomain6> (sfid-20120117_140532_958607_1A1B1135)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit c8f44affb7 ("net: introduce and use netdev_features_t for
device features sets") added netdev_features_t to ndo_set_features.
Change ath6kl to use the new type.

This fixes a warning:

ath6kl/main.c:1170: warning: initialization from incompatible pointer type

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0a6d6e2..3a3b2cc 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1021,7 +1021,8 @@ static struct net_device_stats *ath6kl_get_stats(struct net_device *dev)
 	return &vif->net_stats;
 }
 
-static int ath6kl_set_features(struct net_device *dev, u32 features)
+static int ath6kl_set_features(struct net_device *dev,
+			       netdev_features_t features)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	struct ath6kl *ar = vif->ar;

