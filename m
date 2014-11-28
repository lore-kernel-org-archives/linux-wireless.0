Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13327 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaK1LdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 06:33:14 -0500
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] nl80211: Fix a null dereference issue in nl80211_send_iface on removal
Date: Fri, 28 Nov 2014 13:32:59 +0200
Message-Id: <1417174379-7150-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141128_123317_336378_911A7066)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need trying to add any channels information in the nelink
message when the interface is being removed.

This fixes this kernel panic issue:

[    6.275502] Call Trace:
[    6.275690]  [<ffffffff814e6044>] dump_stack+0x4e/0x71
[    6.276069]  [<ffffffff8108fbe1>] ? console_unlock+0x1f1/0x4d0
[    6.276498]  [<ffffffff81040bbc>] warn_slowpath_common+0x7c/0xa0
[    6.276939]  [<ffffffff81040cca>] warn_slowpath_null+0x1a/0x20
[    6.277368]  [<ffffffff813f9677>] nl80211_send_chandef+0x127/0x130
[    6.277821]  [<ffffffff813f9a35>] nl80211_send_iface+0x3b5/0x5e0
[    6.278281]  [<ffffffff813f9ccc>] nl80211_del_interface+0x6c/0x520
[    6.278736]  [<ffffffff8131b9a4>] genl_family_rcv_msg+0x194/0x330
[    6.279183]  [<ffffffff8131bb40>] ? genl_family_rcv_msg+0x330/0x330
[    6.279644]  [<ffffffff8131bbce>] genl_rcv_msg+0x8e/0xd0
[    6.280047]  [<ffffffff8131b081>] netlink_rcv_skb+0xb1/0xc0
[    6.280679]  [<ffffffff8131b7ed>] ? genl_rcv+0x1d/0x40
[    6.281251]  [<ffffffff8131b7fc>] genl_rcv+0x2c/0x40
[    6.281797]  [<ffffffff81319786>] netlink_unicast+0x156/0x230
[    6.282355]  [<ffffffff8131a0e0>] netlink_sendmsg+0x320/0x410
[    6.282870]  [<ffffffff812d6eb9>] sock_sendmsg+0x69/0x90
[    6.283343]  [<ffffffff812e5b66>] ? verify_iovec+0x56/0xe0
[    6.283830]  [<ffffffff812d71a8>] ___sys_sendmsg.part.38+0x2c8/0x2e0
[    6.284373]  [<ffffffff810889e0>] ? __lock_acquire+0x430/0xbd0
[    6.284882]  [<ffffffff81089aa0>] ? lock_release_non_nested+0xa0/0x300
[    6.285425]  [<ffffffff8111b18c>] ? might_fault+0x8c/0xa0
[    6.285898]  [<ffffffff8111b143>] ? might_fault+0x43/0xa0
[    6.286384]  [<ffffffff812d892e>] __sys_sendmsg+0x4e/0x90
[    6.286849]  [<ffffffff812d897e>] SyS_sendmsg+0xe/0x10
[    6.287312]  [<ffffffff814f0be9>] system_call_fastpath+0x12/0x17

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

@Jouni: Thanks for finding the issue. Can you check this patch fixes it?
	It seems to do the trick for me at least.

 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e41777..018f18d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2372,7 +2372,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			(cfg80211_rdev_list_generation << 2)))
 		goto nla_put_failure;
 
-	if (rdev->ops->get_channel) {
+	if (!removal && rdev->ops->get_channel) {
 		int ret;
 		struct cfg80211_chan_def chandef;
 
-- 
2.0.4

