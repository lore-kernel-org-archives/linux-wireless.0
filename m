Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35167 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161679AbdEYALj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:39 -0400
Received: by mail-pf0-f175.google.com with SMTP id n23so150181089pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:38 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 05/14] mwifiex: re-register wiphy across reset
Date: Wed, 24 May 2017 17:11:10 -0700
Message-Id: <20170525001119.64791-5-briannorris@chromium.org> (sfid-20170525_021432_135132_8D368994)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In general, it's helpful to use the same code for device removal as for
device reset, as this tends to have fewer bugs. Let's move the wiphy
unregistration code into the common reset and removal code.

In particular, it's very hard to properly handle the reset sequence when
something fails. Currently, if mwifiex_reinit_sw() fails, we've failed
to unregister the associated wiphy, and so running something as simple
as "iw phy" can trigger an OOPS, as the wiphy still has hooks back into
freed mwifiex data structures. For example, KASAN complained:

[... see reset fail for other reasons ...]
[ 1184.821158] mwifiex_pcie 0000:01:00.0: info: dnld wifi firmware from 174948 bytes
[ 1186.870914] mwifiex_pcie 0000:01:00.0: info: FW download over, size 608396 bytes
[ 1187.685990] mwifiex_pcie 0000:01:00.0: WLAN FW is active
[ 1187.692673] mwifiex_pcie 0000:01:00.0: cmd_wait_q terminated: -512
[ 1187.699075] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
[ 1187.713476] mwifiex: Failed to bring up adapter: -5
[ 1187.718644] mwifiex_pcie 0000:01:00.0: reinit failed: -5

[... run `iw phy` ...]
[ 1212.902419] ==================================================================
[ 1212.909806] BUG: KASAN: use-after-free in mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex] at addr ffffffc0ad1a8028
[ 1212.920246] Read of size 1 by task iw/3127
[...]
[ 1212.934946] page dumped because: kasan: bad access detected
[...]
[ 1212.950665] Call trace:
[ 1212.953148] [<ffffffc00020a69c>] dump_backtrace+0x0/0x190
[ 1212.958572] [<ffffffc00020a96c>] show_stack+0x20/0x28
[ 1212.963648] [<ffffffc0005ce18c>] dump_stack+0xa4/0xcc
[ 1212.968723] [<ffffffc0003c4430>] kasan_report+0x378/0x500
[ 1212.974140] [<ffffffc0003c3358>] __asan_load1+0x44/0x4c
[ 1212.979462] [<ffffffbffc2e8360>] mwifiex_cfg80211_get_antenna+0x54/0xfc [mwifiex]
[ 1212.987131] [<ffffffbffc084fc4>] nl80211_send_wiphy+0x75c/0x2de0 [cfg80211]
[ 1212.994246] [<ffffffbffc094f60>] nl80211_dump_wiphy+0x32c/0x438 [cfg80211]
[ 1213.001149] [<ffffffc000ab6404>] genl_lock_dumpit+0x48/0x64
[ 1213.006746] [<ffffffc000ab3474>] netlink_dump+0x178/0x398
[ 1213.012171] [<ffffffc000ab3d18>] __netlink_dump_start+0x1bc/0x260
[...]

This all goes away if we just tear down the wiphy on the way down, and
set it back up if/when we bring the device back up.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 3b7316b537ea..be3badba028a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1401,6 +1401,10 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 		rtnl_unlock();
 	}
 	vfree(adapter->chan_stats);
+
+	wiphy_unregister(adapter->wiphy);
+	wiphy_free(adapter->wiphy);
+	adapter->wiphy = NULL;
 }
 
 /*
@@ -1682,9 +1686,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 
 	mwifiex_uninit_sw(adapter);
 
-	wiphy_unregister(adapter->wiphy);
-	wiphy_free(adapter->wiphy);
-
 	if (adapter->irq_wakeup >= 0)
 		device_init_wakeup(adapter->dev, false);
 
-- 
2.13.0.219.gdb65acc882-goog
