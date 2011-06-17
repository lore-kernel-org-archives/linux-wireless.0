Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44729 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab1FQV7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 17:59:07 -0400
Subject: [PATCH] ath5k: add missing ieee80211_free_hw() on unload in AHB code
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 17 Jun 2011 17:59:02 -0400
Message-ID: <20110617215902.23286.82038.stgit@mj.roinet.com> (sfid-20110617_235912_815770_8C1D8CE6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ahb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index ea99827..c38e9e8 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -219,6 +219,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 
 	ath5k_deinit_softc(sc);
 	platform_set_drvdata(pdev, NULL);
+	ieee80211_free_hw(hw);
 
 	return 0;
 }
