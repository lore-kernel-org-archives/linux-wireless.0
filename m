Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAJNEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 08:04:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/13] mac80211_hwsim: verify wmediumd socket
Date: Fri, 10 Jan 2014 13:51:07 +0100
Message-Id: <1389358270-20901-11-git-send-email-johannes@sipsolutions.net> (sfid-20140110_140450_920468_7AD14F1C)
In-Reply-To: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
References: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
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
index 1c51c33..4ee88a9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2112,6 +2112,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	int i;
 	bool found = false;
 
+	if (info->snd_portid != wmediumd_portid)
+		return -EINVAL;
+
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
 	    !info->attrs[HWSIM_ATTR_FLAGS] ||
 	    !info->attrs[HWSIM_ATTR_COOKIE] ||
@@ -2185,6 +2188,9 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	void *frame_data;
 	struct sk_buff *skb = NULL;
 
+	if (info->snd_portid != wmediumd_portid)
+		return -EINVAL;
+
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
 	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
@@ -2237,6 +2243,9 @@ out:
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

