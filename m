Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753054AbdEJIzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 04:55:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] ath9k: check ah->curchan when updating tx power
Date: Wed, 10 May 2017 10:54:54 +0200
Message-Id: <1494406494-13719-1-git-send-email-sgruszka@redhat.com> (sfid-20170510_105748_115986_BD1F76C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When driver fail to reset card ah->curchan value stay NULL. When
later driver try to update tx power it oops by using ah->curchan
(calltrace is shown below).

This problem were reported at various places and for some it was
fixed by making ath9k_hw_chip_reset() do not fail. I have this bug
report on some oldish RHEL kernel with AR9285, however it's hard to
debug where reset fail when kernel OOPS, so I think this patch
should be applied. Hopefully ah->curchan is not used unconditionally
on other places until is initialized on ath9k_config().

ath: phy0: Chip reset failed
ath: phy0: Unable to reset hardware; reset status -22 (freq 2412 MHz)
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<f8a35585>] ath9k_hw_set_txpowerlimit+0x25/0x80 [ath9k_hw]
Oops: 0000 [#1] SMP
<snip>
Call Trace:
 [<f8aac1aa>] ? ath9k_cmn_update_txpow+0x1a/0x30 [ath9k_common]
 [<f8cf4f4e>] ? ath_complete_reset+0x4e/0x130 [ath9k]
 [<f8cf54d7>] ? ath9k_start+0x127/0x1e0 [ath9k]
 [<f8c2e52f>] ? ieee80211_do_open+0x30f/0x910 [mac80211]
 [<c07bd96d>] ? dev_open+0x8d/0xf0

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index c67d0e0..099f3d4 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -369,7 +369,7 @@ void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 {
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
 
-	if (reg->power_limit != new_txpow)
+	if (ah->curchan && reg->power_limit != new_txpow)
 		ath9k_hw_set_txpowerlimit(ah, new_txpow, false);
 
 	/* read back in case value is clamped */
-- 
1.7.1
