Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:44299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaDYBvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:17 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] iwlegacy: Convert /n to \n
Date: Thu, 24 Apr 2014 18:51:00 -0700
Message-Id: <80376e433ad62c5792b72ef5a338df1771bc9975.1398390579.git.joe@perches.com> (sfid-20140425_035318_272773_463DE366)
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlegacy/3945.c     | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index d37a6fd..b598e28 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -573,7 +573,7 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
-		D_DROP("dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d\n",
 		       rx_stats->phy_count);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 888ad5c..c159c05 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -670,7 +670,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	}
 
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		D_DROP("dsp size out of range [0,20]: %d/n",
+		D_DROP("dsp size out of range [0,20]: %d\n",
 		       phy_res->cfg_phy_cnt);
 		return;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

