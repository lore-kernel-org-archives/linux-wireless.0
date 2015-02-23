Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43751 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbBWPg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 10:36:27 -0500
Received: by iebtr6 with SMTP id tr6so24044310ieb.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 07:36:26 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] mac80211_hwsim: support any address in userspace
Date: Mon, 23 Feb 2015 10:33:44 -0500
Message-Id: <1424705624-7964-1-git-send-email-me@bobcopeland.com> (sfid-20150223_163630_784041_8FC6289E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the checks in get_hwsim_data_ref_from_addr, wmediumd
was only able to use the second mac address (those starting with
0x42).  This is confusing and needlessly limiting, so allow any
configured address.

While at it, use ether_addr_equal since data->addresses and the
address from the netlink payload are aligned(2).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1204853..be8bb18 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -907,8 +907,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		goto nla_put_failure;
 	}
 
-	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
-		    ETH_ALEN, data->addresses[1].addr))
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, hdr->addr2))
 		goto nla_put_failure;
 
 	/* We get the skb->data */
@@ -2608,14 +2607,18 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 {
 	struct mac80211_hwsim_data *data;
 	bool _found = false;
+	int i;
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
-			_found = true;
-			break;
+		for (i = 0; i < ARRAY_SIZE(data->addresses); i++) {
+			if (ether_addr_equal(data->addresses[i].addr, addr)) {
+				_found = true;
+				goto end_loop;
+			}
 		}
 	}
+end_loop:
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (!_found)
-- 
2.1.4

