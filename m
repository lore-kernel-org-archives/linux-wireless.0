Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZHIBzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 21:55:20 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH] ath9k: Fix regression on receiving PS poll frames
Date: Sat,  8 Aug 2009 21:55:16 -0400
Message-Id: <1249782916-24001-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the the patch:

ath9k: use new FIF_PSPOLL configure filter

I forgot to add the new FIF_PSPOLL to the supported mask.
Without this we mask out the FIF_PSPOLL flag therefore
we'd ignore it from mac80211.

Cc: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

sorry about that.

 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a9e43f7..efe2e85 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2380,6 +2380,7 @@ skip_chan_change:
 	(FIF_PROMISC_IN_BSS |			\
 	FIF_ALLMULTI |				\
 	FIF_CONTROL |				\
+	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
 	FIF_BCN_PRBRESP_PROMISC |		\
 	FIF_FCSFAIL)
-- 
1.6.3.3

