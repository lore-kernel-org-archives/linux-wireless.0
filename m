Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17138 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1LVGlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 01:41:23 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20210.53767.139322.166202@gargle.gargle.HOWL> (sfid-20111222_074126_873629_D2312C59)
Date: Thu, 22 Dec 2011 12:15:27 +0530
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix panic when setting a channel
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 could pass a NULL net_device to the driver via the
set_channel() callback, when it receives a request to set the
device's channel. Not handling this case properly results in this panic:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000cb0
IP: [<ffffffffa0374e49>] ath6kl_cfg80211_ready+0x9/0x70 [ath6kl_sdio]

Call Trace:
[<ffffffffa0374ed7>] ath6kl_set_channel+0x27/0x90 [ath6kl_sdio]
[<ffffffffa04dfd5f>] cfg80211_set_freq+0xff/0x1d0 [cfg80211]
[<ffffffffa04d3275>] ? nl80211_set_wiphy+0x85/0x660 [cfg80211]
[<ffffffffa04d3198>] __nl80211_set_channel.isra.39+0x118/0x140 [cfg80211]
[<ffffffffa04d34f3>] nl80211_set_wiphy+0x303/0x660 [cfg80211]
[<ffffffff813678d7>] ? rtnl_lock+0x17/0x20
[<ffffffffa04ca165>] ? nl80211_pre_doit+0xb5/0x150 [cfg80211]
[<ffffffff81382a45>] genl_rcv_msg+0x1d5/0x250
[<ffffffff81382870>] ? genl_rcv+0x40/0x40
[<ffffffff81381be9>] netlink_rcv_skb+0xa9/0xd0
[<ffffffff81382855>] genl_rcv+0x25/0x40
[<ffffffff811354f0>] ? might_fault+0x40/0x90
[<ffffffff81381519>] netlink_unicast+0x2d9/0x320
[<ffffffff813818e6>] netlink_sendmsg+0x2c6/0x320
[<ffffffff81343800>] ? sock_update_classid+0xb0/0x110
[<ffffffff8133f52e>] sock_sendmsg+0x10e/0x130
[<ffffffff81169933>] ? mem_cgroup_update_page_stat+0x193/0x250
[<ffffffff811354f0>] ? might_fault+0x40/0x90
[<ffffffff811354f0>] ? might_fault+0x40/0x90
[<ffffffff81135539>] ? might_fault+0x89/0x90
[<ffffffff811354f0>] ? might_fault+0x40/0x90
[<ffffffff8134d126>] ? verify_iovec+0x56/0xd0
[<ffffffff8133f9e6>] __sys_sendmsg+0x396/0x3b0
[<ffffffff8108e823>] ? up_read+0x23/0x40
[<ffffffff81040e68>] ? do_page_fault+0x208/0x4e0
[<ffffffff81193151>] ? vfsmount_lock_local_unlock+0x21/0x60
[<ffffffff811947d0>] ? mntput_no_expire+0x30/0xe0
[<ffffffff8119489f>] ? mntput+0x1f/0x30
[<ffffffff81342149>] sys_sendmsg+0x49/0x90
[<ffffffff81425482>] system_call_fastpath+0x16/0x1b

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c59a21..b120a7e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2014,7 +2014,18 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			      struct ieee80211_channel *chan,
 			      enum nl80211_channel_type channel_type)
 {
-	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl_vif *vif;
+
+	/*
+	 * 'dev' could be NULL if a channel change is required for the hardware
+	 * device itself, instead of a particular VIF.
+	 *
+	 * FIXME: To be handled properly when monitor mode is supported.
+	 */
+	if (!dev)
+		return -EBUSY;
+
+	vif = netdev_priv(dev);
 
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
-- 
1.7.8

