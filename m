Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51903 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYBDCxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 21:53:25 -0500
Date: Sun, 3 Feb 2008 21:53:20 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	johannes@sipsolutions.net
Subject: [PATCH 6/7] ath5k: Use software encryption for now
Message-ID: <6571fb0f1b7c8435e6306745e6cf71366f306440.1202092325.git.mcgrof@winlab.rutgers.edu> (sfid-20080204_025327_162035_D33477EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <67abed819770e9d38c69f0e015e153427b3522be.1202092325.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware encryption doesn't work yet so lets use software
encryption for now.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bfe6836..ef9655c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2922,7 +2922,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch(key->alg) {
 	case ALG_WEP:
-		break;
+	/* XXX: fix hardware encryption, its not working. For now
+	 * allow software encryption */
+		/* break; */
 	case ALG_TKIP:
 	case ALG_CCMP:
 		return -EOPNOTSUPP;
-- 
1.5.3.7

