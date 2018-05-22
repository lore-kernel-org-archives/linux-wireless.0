Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34639 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbeEVAoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 20:44:22 -0400
Received: by mail-pg0-f68.google.com with SMTP id k2-v6so7086554pgc.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 17:44:22 -0700 (PDT)
Received: from iss.ger.corp.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id r80-v6sm32204756pfe.44.2018.05.21.17.44.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 May 2018 17:44:20 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Fix radio dump for radio idx 0
Date: Tue, 22 May 2018 02:43:56 +0200
Message-Id: <20180522004356.19306-1-andrew.zaborowski@intel.com> (sfid-20180522_024425_679876_3ADCDA21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 6335698e24ec11e1324b916177da6721df724dd8 the radio with idx of 0
will not get dumped in HWSIM_CMD_GET_RADIO because of the last_idx
checks.  Offset cb->args[0] by 1 similarly to what is done in nl80211.c.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7bfbc5916e..32d590f4f5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3340,7 +3340,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_dump_radio_nl(struct sk_buff *skb,
 			       struct netlink_callback *cb)
 {
-	int last_idx = cb->args[0];
+	int last_idx = cb->args[0] - 1;
 	struct mac80211_hwsim_data *data = NULL;
 	int res = 0;
 	void *hdr;
@@ -3368,7 +3368,7 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 		last_idx = data->idx;
 	}
 
-	cb->args[0] = last_idx;
+	cb->args[0] = last_idx + 1;
 
 	/* list changed, but no new element sent, set interrupted flag */
 	if (skb->len == 0 && cb->prev_seq && cb->seq != cb->prev_seq) {
-- 
2.14.1
