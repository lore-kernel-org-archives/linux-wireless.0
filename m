Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34754 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388097AbeGTS5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 14:57:08 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ray_cs: remove redundant pointer 'p'
Date: Fri, 20 Jul 2018 19:07:40 +0100
Message-Id: <20180720180740.21018-1-colin.king@canonical.com> (sfid-20180720_200801_758481_8B8AD94F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer 'p' is being assigned but is never used hence it is
redundant and can be removed. Also re-work if statement to remove
redundant assignment of p.

Cleans up clang warning:
warning: variable 'p' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ray_cs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index a7e0a17aa7e8..08c607c031bc 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -470,7 +470,6 @@ static inline struct rcs __iomem *rcs_base(ray_dev_t *dev)
 static int ray_init(struct net_device *dev)
 {
 	int i;
-	UCHAR *p;
 	struct ccs __iomem *pccs;
 	ray_dev_t *local = netdev_priv(dev);
 	struct pcmcia_device *link = local->finder;
@@ -513,12 +512,9 @@ static int ray_init(struct net_device *dev)
 	init_startup_params(local);
 
 	/* copy mac address to startup parameters */
-	if (parse_addr(phy_addr, local->sparm.b4.a_mac_addr)) {
-		p = local->sparm.b4.a_mac_addr;
-	} else {
+	if (!parse_addr(phy_addr, local->sparm.b4.a_mac_addr)) {
 		memcpy(&local->sparm.b4.a_mac_addr,
 		       &local->startup_res.station_addr, ADDRLEN);
-		p = local->sparm.b4.a_mac_addr;
 	}
 
 	clear_interrupt(local);	/* Clear any interrupt from the card */
-- 
2.17.1
