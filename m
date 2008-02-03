Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:42008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763434AbYBCOvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:43 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1586229fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/19] rt2x00: Fix tx parameter initialization
Date: Sun, 3 Feb 2008 15:47:30 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031547.30569.IvDoorn@gmail.com> (sfid-20080203_145146_577278_87A30D3B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check if the aifs, cw_min and cw_max are above 0
when determining if the default should be used.
Tor aifs a negative number is used to determine
if the default should be used or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 411ed5d..380cc5b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -396,17 +396,17 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue_idx,
 	 * The passed variables are stored as real value ((2^n)-1).
 	 * Ralink registers require to know the bit number 'n'.
 	 */
-	if (params->cw_min)
+	if (params->cw_min > 0)
 		queue->cw_min = fls(params->cw_min);
 	else
 		queue->cw_min = 5; /* cw_min: 2^5 = 32. */
 
-	if (params->cw_max)
+	if (params->cw_max > 0)
 		queue->cw_max = fls(params->cw_max);
 	else
 		queue->cw_max = 10; /* cw_min: 2^10 = 1024. */
 
-	if (params->aifs)
+	if (params->aifs >= 0)
 		queue->aifs = params->aifs;
 	else
 		queue->aifs = 2;
-- 
1.5.3.8

