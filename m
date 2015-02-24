Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:40257 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbBXNkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 08:40:31 -0500
Received: by iebtr6 with SMTP id tr6so31866180ieb.7
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 05:40:30 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2] mac80211_hwsim: support any address in userspace
Date: Tue, 24 Feb 2015 08:39:44 -0500
Message-Id: <1424785184-4427-1-git-send-email-me@bobcopeland.com> (sfid-20150224_144034_932034_693F25CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the checks in get_hwsim_data_ref_from_addr, wmediumd
was only able to use the second mac address (those starting with
0x42).  This is confusing and needlessly limiting, so allow any
configured address.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

v2: use mac80211_hwsim_addr_match instead which checks active
    interface addresses instead of pre-configured 'hardware'
    addresses (Johannes)

 drivers/net/wireless/mac80211_hwsim.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1204853..3555251 100644
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
@@ -2611,7 +2610,7 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
+		if (mac80211_hwsim_addr_match(data, addr)) {
 			_found = true;
 			break;
 		}
-- 
2.1.4

