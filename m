Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52459 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0ACVQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 16:16:25 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 88CCCEBC51
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:08:22 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 338072BD45
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:08:21 +0200 (EET)
Subject: [PATCH 9/9] wl1251: fix sleep related error paths in
	wl1251_op_bss_info_changed()
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 03 Jan 2010 23:08:20 +0200
Message-ID: <20100103210820.29287.1508.stgit@tikku>
In-Reply-To: <20100103210552.29287.20384.stgit@tikku>
References: <20100103210552.29287.20384.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

In various cases wl1251_op_bss_info_changed() did not call elp_sleep()
after an error was noticed. Fix it by using correct goto label.

The bug was a theoretical one, in practise it doesn't matter because
if commands start returning errors there will be lots of other problems.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4728983..f17ce06 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -946,7 +946,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 					      skb->data, skb->len);
 		dev_kfree_skb(skb);
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
 			ret = wl1251_join(wl, wl->bss_type, wl->channel,
@@ -1018,7 +1018,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1251_acx_cts_protect(wl, CTSPROTECT_DISABLE);
 		if (ret < 0) {
 			wl1251_warning("Set ctsprotect failed %d", ret);
-			goto out;
+			goto out_sleep;
 		}
 	}
 
@@ -1029,7 +1029,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (ret < 0) {
 			dev_kfree_skb(beacon);
-			goto out;
+			goto out_sleep;
 		}
 
 		ret = wl1251_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
@@ -1038,13 +1038,13 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		dev_kfree_skb(beacon);
 
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 
 		ret = wl1251_join(wl, wl->bss_type, wl->beacon_int,
 				  wl->channel, wl->dtim_period);
 
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 	}
 
 out_sleep:

