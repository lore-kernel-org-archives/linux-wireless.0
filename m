Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4341 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbXJWSI4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 14:08:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: undo overzealous hunk of "ath5k: avoid oops when..."
Date: Tue, 23 Oct 2007 13:43:23 -0400
Message-Id: <11931614033102-git-send-email-linville@tuxdriver.com> (sfid-20071023_191016_371960_38BD3AD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first hunk of "ath5k: avoid oops when ah_capabilities.cap_mode not
set" was ill-advised.  It can cause the it's loop to abort prematurely.

Signed-off-by: John W. Linville <linville.tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c38adab..e764fd3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1991,9 +1991,6 @@ static int ath5k_getchannels(struct ieee80211_hw *hw)
 		}
 
 		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
-		if (!hw_rates)
-			return -EINVAL;
-
 		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
 			max_r);
 		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
-- 
1.5.2.4

