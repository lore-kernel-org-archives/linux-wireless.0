Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:63850 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933487AbeCGRLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 12:11:50 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>,
        <syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH] mac80211_hwsim: fixed use-after-free bug in hwsim_exit_net
Date: Wed, 7 Mar 2018 18:11:07 +0100
Message-ID: <20180307171107.2803-1-benjamin.beichler@uni-rostock.de> (sfid-20180307_181212_058077_55DB7FFA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When destroying a net namespace, all hwsim interfaces, which are not
created in default namespace are deleted. But the async deletion of the
interfaces could last longer than the actual destruction of the
namespace, which results to an use after free bug. Therefore use
synchronous deletion in this case.

Fixes: 100cb9ff40e0 ("mac80211_hwsim: Allow managing radios from
non-initial namespaces")
Reported-by: syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com
Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b6c3640a94f..93a7ae34653e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3528,8 +3528,12 @@ static void __net_exit hwsim_exit_net(struct net *net)
 		list_del(&data->list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
-		INIT_WORK(&data->destroy_work, destroy_radio);
-		queue_work(hwsim_wq, &data->destroy_work);
+		hwsim_radios_generation++;
+		spin_unlock_bh(&hwsim_radio_lock);
+		mac80211_hwsim_del_radio(data,
+					 wiphy_name(data->hw->wiphy),
+					 NULL);
+		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
 
-- 
2.16.2
