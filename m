Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34276 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbbLSPBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2015 10:01:10 -0500
Received: by mail-qg0-f50.google.com with SMTP id 74so7669007qgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2015 07:01:10 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, arwelle@cert.org,
	greearb@candelatech.com, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] Revert "mac80211_hwsim: support any address in userspace"
Date: Sat, 19 Dec 2015 09:59:37 -0500
Message-Id: <1450537177-27440-1-git-send-email-me@bobcopeland.com> (sfid-20151219_160119_463041_688C8C12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit cd37a90b2a417e5882414e19954eeed174aa4d29.

Different userspace programs interpreted HWSIM_ATTR_ADDR_TRANSMITTER
and HWSIM_ATTR_ADDR_RECEIVER differently: some expected it to
be an unchanging hardware address that is tied to the radio despite
which address is configured on the interface, while others expected
to be a copy of the address in the frame (the configured address).
The intent of the original authors is unclear.

The latter interpretation doesn't really work properly with multiple
vifs and broadcast frames.  Also, as the TA is already in the
frame, userspace programs can actually support configured addresses
in the former interpretation by mapping between them and the supplied
HWSIM_ATTR_ADDR_TRANSMITTER.

So, in the interest of API stability, revert to the previous mode
of operation and going forward use the former interpretation.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
I made minimal changes to wmediumd and it works fine so far with the
revert.  I've a little more to do there, but it is good enough that
hostapd test case passes with the new wmediumd binary, with or without
this patch.

 drivers/net/wireless/mac80211_hwsim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c32889a1e39c..a28414c50edf 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -991,7 +991,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		goto nla_put_failure;
 	}
 
-	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, hdr->addr2))
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		    ETH_ALEN, data->addresses[1].addr))
 		goto nla_put_failure;
 
 	/* We get the skb->data */
@@ -2736,7 +2737,7 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (mac80211_hwsim_addr_match(data, addr)) {
+		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
 			_found = true;
 			break;
 		}
-- 
2.6.1

