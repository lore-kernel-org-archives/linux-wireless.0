Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24801 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab0BDNeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 08:34:16 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o14DWwI2022138
	for <linux-wireless@vger.kernel.org>; Thu, 4 Feb 2010 15:34:09 +0200
Received: from [127.0.1.1] (essapo-nirac25321.europe.nokia.com [10.162.253.21])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o14DXSmE006097
	for <linux-wireless@vger.kernel.org>; Thu, 4 Feb 2010 15:33:29 +0200
Subject: [PATCH] wl1251: fix txop unit
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 04 Feb 2010 15:33:25 +0200
Message-ID: <20100204133325.10883.24828.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

mac80211 uses unit units of 32 usec with txop but wl1251_acx_ac_cfg()
expects it to be usecs. This fortunately didn't cause any severe problems,
only that firmware was using incorrect WMM settings.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index a717dde..24ae6a3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1144,9 +1144,10 @@ static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	if (ret < 0)
 		goto out;
 
+	/* mac80211 uses units of 32 usec */
 	ret = wl1251_acx_ac_cfg(wl, wl1251_tx_get_queue(queue),
 				params->cw_min, params->cw_max,
-				params->aifs, params->txop);
+				params->aifs, params->txop * 32);
 	if (ret < 0)
 		goto out_sleep;
 

