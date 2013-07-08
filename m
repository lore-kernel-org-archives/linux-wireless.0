Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48270 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab3GHOIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 06/20] rt2x00: rt2800lib: fix BBP1_TX_ANTENNA field configuration for 3T devices
Date: Mon,  8 Jul 2013 16:08:21 +0200
Message-Id: <1373292515-21332-7-git-send-email-juhosg@openwrt.org> (sfid-20130708_160855_731049_D82EE26E)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The field must be set to 2 instead of 0 for
devices with three TX chains.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e817278..1a6a4eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1763,7 +1763,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 			rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 2);
 		break;
 	case 3:
-		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
+		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 2);
 		break;
 	}
 
-- 
1.7.10

