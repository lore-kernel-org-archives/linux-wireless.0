Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaAGXQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:16:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 10/12] mac80211_hwsim: verify wmediumd socket
Date: Wed,  8 Jan 2014 00:15:15 +0100
Message-Id: <1389136517-21216-11-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001700_479247_2CAA3E5B)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There can't be two wmediumd instances controlling hwsim,
so reject registration from a second one and verify in
the commands that it's the correct instance calling.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 34996d4..68375f7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2109,6 +2109,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	int i;
 	bool found = false;
 
+	if (info->snd_portid != wmediumd_portid)
+		return -EINVAL;
+
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
 	    !info->attrs[HWSIM_ATTR_FLAGS] ||
 	    !info->attrs[HWSIM_ATTR_COOKIE] ||
@@ -2182,6 +2185,9 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	void *frame_data;
 	struct sk_buff *skb = NULL;
 
+	if (info->snd_portid != wmediumd_portid)
+		return -EINVAL;
+
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
 	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
@@ -2234,6 +2240,9 @@ out:
 static int hwsim_register_received_nl(struct sk_buff *skb_2,
 				      struct genl_info *info)
 {
+	if (wmediumd_portid)
+		return -EBUSY;
+
 	wmediumd_portid = info->snd_portid;
 
 	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
-- 
1.8.5.1

