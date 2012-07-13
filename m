Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45201 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362Ab2GMSwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 14:52:35 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, coelho@ti.com,
	johannes.berg@intel.com
Subject: [PATCH 1/2] mac80211_hwsim: fix possible race condition in usage of info->control.sta & control.vif
Date: Fri, 13 Jul 2012 20:52:24 +0200
Message-Id: <1342205545-45382-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120713_205240_575446_3238342F)
In-Reply-To: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

info->control.sta and control.vif may only be dereferenced during the
drv_tx call otherwise could lead to use-after-free bugs.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3f38d84..826ac7b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1540,11 +1540,6 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	/* now send back TX status */
 	txi = IEEE80211_SKB_CB(skb);
 
-	if (txi->control.vif)
-		hwsim_check_magic(txi->control.vif);
-	if (txi->control.sta)
-		hwsim_check_sta_magic(txi->control.sta);
-
 	ieee80211_tx_info_clear_status(txi);
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-- 
1.7.11.1

