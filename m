Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51910 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYBDCx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 21:53:56 -0500
Date: Sun, 3 Feb 2008 21:53:51 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	johannes@sipsolutions.net, bunk@kernel.org
Subject: [PATCH 7/7] ath5k/phy.c: fix negative array index
Message-ID: <5b486ef9da13204e3068cc4b3346a89b3c9911ac.1202092325.git.mcgrof@winlab.rutgers.edu> (sfid-20080204_025358_752294_8514590B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <67abed819770e9d38c69f0e015e153427b3522be.1202092325.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Author: Adrian Bunk <bunk@kernel.org>

This patch fixes a negative array index spotted by the Coverity checker.

Changes-licensed-under: ISC

Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 248c0f5..405195f 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1178,6 +1178,9 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 			(channel->center_freq >= 5260 ? 1 :
 			    (channel->center_freq > 4000 ? 0 : -1)));
 
+		if (obdb == -1)
+			return -EINVAL;
+
 		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
 			return -EINVAL;
-- 
1.5.3.7

