Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38871 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1CBJsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:48:33 -0500
Received: by bwz15 with SMTP id 15so5409512bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 01:48:32 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, coelho@ti.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] wl12xx: Correctly set up protection if non-GF STAs are present
Date: Wed,  2 Mar 2011 10:46:46 +0100
Message-Id: <1299059206-3919-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I don't know wl12xx as all and I don't have such a device. This is based on the
assumption that setting acx->gf_protection to 1 enables protection for GF
transmissions. So, this is only compile tested.

It just popped up while discussing HT operation mode handling in hostapd.

Please review.
 
Thanks,
Helmut

 drivers/net/wireless/wl12xx/acx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 3badc6b..a3db755 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1361,7 +1361,8 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 	acx->ht_protection =
 		(u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
 	acx->rifs_mode = 0;
-	acx->gf_protection = 0;
+	acx->gf_protection =
+		!!(ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 	acx->ht_tx_burst_limit = 0;
 	acx->dual_cts_protection = 0;
 
-- 
1.7.1

