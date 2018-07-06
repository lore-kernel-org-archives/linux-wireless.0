Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:15143 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932352AbeGFOt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 10:49:56 -0400
Date: Fri, 6 Jul 2018 22:48:58 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH] mt76: mt76x0_burst_read_regs() can be static
Message-ID: <20180706144857.GA29077@lkp-wsm-ep1> (sfid-20180706_165000_489015_CDED27DD)
References: <1530875029-26274-13-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530875029-26274-13-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes: c1f1ff1a3d63 ("mt76: Kconfig and Makefile for mt76x0 driver")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 mcu.c |    4 ++--
 phy.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index aafa3f3..0c9da79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -341,8 +341,8 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 					data + cnt, n - cnt);
 }
 
-int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
-			   struct mt76_reg_pair *data, int n)
+static int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
+				  struct mt76_reg_pair *data, int n)
 {
 	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 0830280..e52a506 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -986,7 +986,7 @@ mt76x0_rf_init(struct mt76x0_dev *dev)
 	rf_set(dev, MT_RF(0, 4), 0x80);
 }
 
-void mt76x0_ant_select(struct mt76x0_dev *dev)
+static void mt76x0_ant_select(struct mt76x0_dev *dev)
 {
 	/* Single antenna mode. */
 	mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
