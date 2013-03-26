Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55111 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3CZRfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:35:30 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwlegacy: 4965-rs: avoid null pointer dereference error
Date: Tue, 26 Mar 2013 17:35:23 +0000
Message-Id: <1364319323-14272-1-git-send-email-colin.king@canonical.com> (sfid-20130326_183535_219846_B1A0E27D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

il4965_rs_initialize_lq checks to see if sta is null, however, before that
check il4965_rs_use_green dereferences sta when intializing use_green.
Avoid a potential null pointer dereference error by only calling
il4965_rs_use_green after we are sure sta is not null.

Smatch analysis:

drivers/net/wireless/iwlegacy/4965-rs.c:2160 il4965_rs_initialize_lq() warn:
  variable dereferenced before check 'sta' (see line 2155)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index e8324b5..6c7493c 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2152,7 +2152,7 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	int rate_idx;
 	int i;
 	u32 rate;
-	u8 use_green = il4965_rs_use_green(il, sta);
+	u8 use_green;
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 	struct il_station_priv *sta_priv;
@@ -2160,6 +2160,7 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	if (!sta || !lq_sta)
 		return;
 
+	use_green = il4965_rs_use_green(il, sta);
 	sta_priv = (void *)sta->drv_priv;
 
 	i = lq_sta->last_txrate_idx;
-- 
1.8.1.2

