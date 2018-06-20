Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0096.outbound.protection.outlook.com ([104.47.1.96]:25434
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750793AbeFTKrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 06:47:16 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v4 3/5] batman-adv: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Wed, 20 Jun 2018 13:46:56 +0300
Message-Id: <1529491616-23222-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180620_124738_353115_CE2B25D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BIT macro uses unsigned long which some architectures handle as 32 bit
and therefore might cause macro's shift to overflow when used on a value
equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with all NL80211_STA_INFO_* attribute types instead of BIT
to prevent future possible bugs when one will use BIT macro for higher
attributes by mistake.

This commit cleans up all usages of BIT macro with the above field
in batman-adv by changing it to BIT_ULL instead.

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
---
 net/batman-adv/bat_v_elp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 71c20c1..2f0de55 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -114,7 +114,8 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 		}
 		if (ret)
 			goto default_throughput;
-		if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+		if (!(sinfo.filled &
+			  BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
 			goto default_throughput;
 
 		return sinfo.expected_throughput / 100;
-- 
2.7.4
