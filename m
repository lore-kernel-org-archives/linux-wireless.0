Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35709 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbcCRC3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:29:24 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so146113239pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:29:19 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH MOREWORK 18/19] iwl4965: Fix more memory leaks in __il4965_up()
Date: Fri, 18 Mar 2016 13:29:11 +1100
Message-Id: <6bec5a9b55f13d40c2803f0fa60173451d5ea14a.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032928_343261_F24E53A1)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some of the non-success return paths, the memory allocated by
iwl4965_sta_alloc_lq() in iwl4965_alloc_bcast_station() is not freed.

In particular:
 - if the card isn't ready after il4965_prepare_card_hw()
 - if the card is hardware-rfkilled

In the hardware rfkilled path, the driver enables the rfkill
interrupt. When the card is unrfkilled and this interrupt is raised
we end up calling il4965_bg_restart() which calls __il4965_up() which
calls iwl4965_alloc_bcast_station() again.

Suggested-by: Jia-Ju Bai <baijiaju1990@163.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

This is only compile tested as I don't have compatible hardware. I also
don't know the driver enough to know that this is truly correct - however
it looks right and I stand by my analysis.

Could someone else please review this?

Thanks,

Julian Calaby
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 30d9dd3..f9ed480 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5553,6 +5553,7 @@ __il4965_up(struct il_priv *il)
 
 	il4965_prepare_card_hw(il);
 	if (!il->hw_ready) {
+		il_dealloc_bcast_stations(il);
 		IL_ERR("HW not ready\n");
 		return -EIO;
 	}
@@ -5564,6 +5565,7 @@ __il4965_up(struct il_priv *il)
 		set_bit(S_RFKILL, &il->status);
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
 
+		il_dealloc_bcast_stations(il);
 		il_enable_rfkill_int(il);
 		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return 0;
-- 
2.7.0

