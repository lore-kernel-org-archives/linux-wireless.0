Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46273 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336Ab3EBMaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:11 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 04/14] rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
Date: Thu,  2 May 2013 14:30:19 +0200
Message-Id: <1367497829-7672-5-git-send-email-juhosg@openwrt.org> (sfid-20130502_143101_389276_CB1207C1)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon data queue is initialized already,
so fetch the number of the queue entries from
that instead of using the entry_num field of
the data queue descriptor.

The two values are the same, and the use of the
rt2x00dev->bcn->limit value allows us to get rid
of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6a20172..dff5012 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1336,7 +1336,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 * beacon entries.
 	 */
 	rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-	if (rt2x00dev->ops->bcn->entry_num > 0)
+	if (rt2x00dev->bcn->limit > 0)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
-- 
1.7.10

