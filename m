Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:45597 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806Ab3KBN6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 09:58:14 -0400
Date: Sat, 2 Nov 2013 15:57:36 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211_hwsim: Fix radiotap header for ACK frames
Message-ID: <20131102135736.GA14411@w1.fi> (sfid-20131102_145901_833460_8167ADF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The earlier addition of rt_tsft to struct hwsim_radiotap_hdr updated
only mac80211_hwsim_monitor_tx() to fill in the new field.
mac80211_hwsim_monitor_ack() did not set the rt_tsft field and as such,
leaked eight bytes of kernel memory to user space. In addition, the
resulting radiotap header is invalid since the field offsets do not
match. Fix these issues by defining a separate radiotap header structure
for the ACK frame case which does not use all the fields.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 drivers/net/wireless/mac80211_hwsim.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2cd3f54..ea315a1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -382,6 +382,14 @@ struct hwsim_radiotap_hdr {
 	__le16 rt_chbitmask;
 } __packed;
 
+struct hwsim_radiotap_ack_hdr {
+	struct ieee80211_radiotap_header hdr;
+	u8 rt_flags;
+	u8 pad;
+	__le16 rt_channel;
+	__le16 rt_chbitmask;
+} __packed;
+
 /* MAC80211_HWSIM netlinf family */
 static struct genl_family hwsim_genl_family = {
 	.id = GENL_ID_GENERATE,
@@ -499,7 +507,7 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
 				       const u8 *addr)
 {
 	struct sk_buff *skb;
-	struct hwsim_radiotap_hdr *hdr;
+	struct hwsim_radiotap_ack_hdr *hdr;
 	u16 flags;
 	struct ieee80211_hdr *hdr11;
 
@@ -510,14 +518,14 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
 	if (skb == NULL)
 		return;
 
-	hdr = (struct hwsim_radiotap_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr = (struct hwsim_radiotap_ack_hdr *) skb_put(skb, sizeof(*hdr));
 	hdr->hdr.it_version = PKTHDR_RADIOTAP_VERSION;
 	hdr->hdr.it_pad = 0;
 	hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
 	hdr->hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
 	hdr->rt_flags = 0;
-	hdr->rt_rate = 0;
+	hdr->pad = 0;
 	hdr->rt_channel = cpu_to_le16(chan->center_freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	hdr->rt_chbitmask = cpu_to_le16(flags);
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
