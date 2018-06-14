Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:35568
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754764AbeFNKMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 06:12:24 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v2 3/5] batman: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 13:12:17 +0300
Message-Id: <1528971137-432-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121232_343151_20D9026F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with NL80211_STA_INFO_* attribute types instead of BIT.

The BIT macro uses unsigned long type which some architectures handle as 32bit
and this results in compilation warnings such as:

net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
  sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
  ^

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
---
 net/batman-adv/bat_v_elp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 71c20c1..71e6474 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -114,7 +114,7 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 		}
 		if (ret)
 			goto default_throughput;
-		if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+		if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
 			goto default_throughput;
 
 		return sinfo.expected_throughput / 100;
-- 
2.7.4
