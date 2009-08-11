Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:49554 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHKM4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 08:56:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] iw: fix typos in MCS set parsing code
Date: Tue, 11 Aug 2009 08:47:30 +0200
Message-Id: <1249973250-9235-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code uses wrong binary operator for masking,
and the shift values for the 'tx_max_num_spatial_streams' and
'tx_unequal_modulation' fields are off-by-one.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 info.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index 2db0fc7..542745b 100644
--- a/info.c
+++ b/info.c
@@ -159,8 +159,8 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			max_rx_supp_data_rate = ((mcs[10] >> 8) & ((mcs[11] & 0x3) << 8));
 			tx_mcs_set_defined = !!(mcs[12] & (1 << 0));
 			tx_mcs_set_equal = !(mcs[12] & (1 << 1));
-			tx_max_num_spatial_streams = (mcs[12] | ((1 << 3) | (1 << 4))) + 1;
-			tx_unequal_modulation = !!(mcs[12] & (1 << 5));
+			tx_max_num_spatial_streams = (mcs[12] & ((1 << 2) | (1 << 3))) + 1;
+			tx_unequal_modulation = !!(mcs[12] & (1 << 4));
 
 			if (max_rx_supp_data_rate)
 				printf("\t\tHT Max RX data rate: %d Mbps\n", max_rx_supp_data_rate);
-- 
1.5.3.2

