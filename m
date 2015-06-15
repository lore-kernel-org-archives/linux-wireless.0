Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:46359 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbFORcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 13:32:52 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] wireless: ipw2100: fix timeout bug - always evaluated to 0
Date: Mon, 15 Jun 2015 19:24:35 +0200
Message-Id: <1434389075-4693-1-git-send-email-hofrat@osadl.org> (sfid-20150615_193316_387006_87A08953)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit: commit 2c86c275015c ("Add ipw2100 wireless driver.") introduced 
HW_PHY_OFF_LOOP_DELAY (HZ / 5000) which always evaluated to 0. Clarified
by Stanislav Yakovlev <stas.yakovlev@gmail.com> that it should be 50
milliseconds thus fixed up to msecs_to_jiffies(50).

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with x86_64_defconfig + CONFIG_IPW2100=m
(with a few buildwarnings in ipw2100.c though not related to this patch)

Patch is against 4.1-rc7 (localversion-next is -next-20150615)

 drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 08eb229..36818c7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1410,7 +1410,7 @@ static int ipw2100_power_cycle_adapter(struct ipw2100_priv *priv)
 static int ipw2100_hw_phy_off(struct ipw2100_priv *priv)
 {
 
-#define HW_PHY_OFF_LOOP_DELAY (HZ / 5000)
+#define HW_PHY_OFF_LOOP_DELAY (msecs_to_jiffies(50))
 
 	struct host_command cmd = {
 		.host_command = CARD_DISABLE_PHY_OFF,
-- 
1.7.10.4

