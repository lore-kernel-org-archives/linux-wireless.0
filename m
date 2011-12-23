Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1LWHOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/10] iwlegacy: off by one in iwl3945_hw_build_tx_cmd_rate()
Date: Fri, 23 Dec 2011 08:13:42 +0100
Message-Id: <1324624430-3688-2-git-send-email-sgruszka@redhat.com> (sfid-20111223_081419_612792_B23932A7)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We use "rate_index" like this:
	rate = iwl3945_rates[rate_index].plcp;
The iwl3945_rates[] array has IWL_RATE_COUNT_3945 elements so the
limit here is off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 863664f..0b99deb 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -683,7 +683,7 @@ il3945_hw_build_tx_cmd_rate(struct il_priv *il, struct il_device_cmd *cmd,
 			    struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(il->hw, info)->hw_value;
-	u16 rate_idx = min(hw_value & 0xffff, RATE_COUNT_3945);
+	u16 rate_idx = min(hw_value & 0xffff, RATE_COUNT_3945 - 1);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
-- 
1.7.4.4

