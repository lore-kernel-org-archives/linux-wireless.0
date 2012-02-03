Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab2BCQcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:55 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 13/25] iwlegacy: get rid of ctx->station_flags
Date: Fri,  3 Feb 2012 17:31:49 +0100
Message-Id: <1328286721-11309-14-git-send-email-sgruszka@redhat.com> (sfid-20120203_173338_610316_BA288D07)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |    2 +-
 drivers/net/wireless/iwlegacy/common.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 7c7ea77..ac26985 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1950,7 +1950,7 @@ il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
 	station->sta.sta.sta_id = sta_id;
-	station->sta.station_flags = ctx->station_flags;
+	station->sta.station_flags = 0;
 
 	if (sta) {
 		struct il_station_priv_common *sta_priv;
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 811e768..a872175 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1169,8 +1169,6 @@ struct il_rxon_context {
 
 	struct il_qos_info qos_data;
 
-	__le32 station_flags;
-
 	struct {
 		bool non_gf_sta_present;
 		u8 protection;
-- 
1.7.1

