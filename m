Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52026 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbLCGyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 01:54:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: wireless-testing regression: Could not configure driver mode
Date: Thu, 03 Dec 2015 08:54:16 +0200
Message-ID: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_075426_533282_0EE08AA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

with latest wireless-testing[1] I noticed that I cannot start AP mode
anymore with ath10k:

nl80211: Subscribe to mgmt frames with AP handle 0x9e5b410
nl80211: Register frame type=0xb0 nl_handle=0x9e5b410 match=
nl80211: Register frame command failed (type=176): ret=-95 (Operation not supported)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Could not configure driver mode

With help of Johannes we find out that there are odd changes in
wireless-testing[2]. Reverting the change in cfg.c fixed my regression,
but I don't know really know what has happened.

Kalle

[1] To be exact I was using ath.git master branch but that's just
    wireless-testing plus latest ath patches so should affect here.

[2] $ git diff master-2015-11-27..master-2015-11-30 -- net/mac80211
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d1c4c35186d..b3a708366a5a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3384,8 +3384,6 @@ const struct cfg80211_ops mac80211_config_ops = {
        .set_bitrate_mask = ieee80211_set_bitrate_mask,
        .remain_on_channel = ieee80211_remain_on_channel,
        .cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
-       .mgmt_tx = ieee80211_mgmt_tx,
-       .mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
        .set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
        .mgmt_frame_register = ieee80211_mgmt_frame_register,
        .set_antenna = ieee80211_set_antenna,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index ce8e1a6c7281..cfd3356e26fd 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -916,6 +916,13 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
                        kfree_skb(skb);
                        goto out_unlock;
                }
+       } else {
+               /* Assign a dummy non-zero cookie, it's not sent to
+                * userspace in this case but we rely on its value
+                * internally in the need_offchan case to distinguish
+                * mgmt-tx from remain-on-channel.
+                */
+               *cookie = 0xffffffff;
        }
 
        if (!need_offchan) {

