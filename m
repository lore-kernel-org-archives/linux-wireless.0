Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12431 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2CLCVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 22:21:43 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20317.23955.98335.809864@gargle.gargle.HOWL> (sfid-20120312_032147_387072_9CF7F3EA)
Date: Mon, 12 Mar 2012 07:51:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix BTCOEX shutdown
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flush MCI profiles only if MCI is being actually used.
This fixes a panic on driver unload when non-MCI devices
are being used and btcoex_enable is set.

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa06296d2>] ath_mci_flush_profile+0x12/0x100 [ath9k]
Call Trace:
[<ffffffffa061befe>] ath9k_stop_btcoex+0x5e/0x80 [ath9k]
[<ffffffffa061ed57>] ath9k_stop+0xb7/0x230 [ath9k]
[<ffffffffa0533f30>] ieee80211_stop_device+0x50/0x180 [mac80211]
[<ffffffffa051f0cf>] ieee80211_do_stop+0x2af/0x6a0 [mac80211]
[<ffffffffa051f4da>] ieee80211_stop+0x1a/0x20 [mac80211]
[<ffffffff81365d96>] __dev_close_many+0x86/0xe0
[<ffffffff81365ee0>] dev_close_many+0xa0/0x110
[<ffffffff81366038>] rollback_registered_many+0xe8/0x260
[<ffffffff813661cb>] unregister_netdevice_many+0x1b/0x80
[<ffffffffa051e950>] ieee80211_remove_interfaces+0xd0/0x110 [mac80211]
[<ffffffffa050c133>] ieee80211_unregister_hw+0x53/0x120 [mac80211]
[<ffffffffa061d5a4>] ath9k_deinit_device+0x44/0x70 [ath9k]
[<ffffffffa062c1d4>] ath_pci_remove+0x54/0xa0 [ath9k]
[<ffffffff81267c46>] pci_device_remove+0x46/0x110
[<ffffffff8131021c>] __device_release_driver+0x7c/0xe0
[<ffffffff81310960>] driver_detach+0xd0/0xe0
[<ffffffff81310078>] bus_remove_driver+0x88/0xe0
[<ffffffff81311122>] driver_unregister+0x62/0xa0
[<ffffffff81268004>] pci_unregister_driver+0x44/0xc0
[<ffffffffa062c8b5>] ath_pci_exit+0x15/0x20 [ath9k]
[<ffffffffa063205d>] ath9k_exit+0x15/0x31 [ath9k]
[<ffffffff810b92cc>] sys_delete_module+0x18c/0x270
[<ffffffff814373dd>] ? retint_swapgs+0x13/0x1b
[<ffffffff8124828e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff81437de9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 63e4c4b1..fbe23de 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -362,7 +362,8 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
 		ath9k_hw_btcoex_disable(ah);
 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
-		ath_mci_flush_profile(&sc->btcoex.mci);
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_MCI)
+			ath_mci_flush_profile(&sc->btcoex.mci);
 	}
 }
 
-- 
1.7.9.3

