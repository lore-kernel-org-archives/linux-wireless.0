Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:41198 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZCJK3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 06:29:01 -0400
Date: Tue, 10 Mar 2009 12:29:21 +0200
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 1/3] ath5k: Choose the right initvals for RF2425
Message-ID: <20090310102921.GB3341@makis> (sfid-20090310_112905_870104_43C09481)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix a typo in initvals.c so that we use the RF2425 array for RF2425 and not RF2413

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/initvals.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 4488643..61fb621 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1510,8 +1510,8 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					rf2425_ini_mode_end, mode);
 
 			ath5k_hw_ini_registers(ah,
-					ARRAY_SIZE(rf2413_ini_common_end),
-					rf2413_ini_common_end, change_channel);
+					ARRAY_SIZE(rf2425_ini_common_end),
+					rf2425_ini_common_end, change_channel);
 
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),

