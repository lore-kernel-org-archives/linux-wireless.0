Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43293 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbZFJQ01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:26:27 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:26:30 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Fix panic when ath9k is unloaded.
Date: Wed, 10 Jun 2009 21:55:33 +0530
Message-ID: <1244651133-6537-9-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-8-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-3-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-6-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-7-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-8-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFKILL deinit should happen after the device is unregistered with
mac80211.

EIP: 0060:[<f8a52231>] EFLAGS: 00010286 CPU: 1
EIP is at rfkill_pause_polling+0x11/0x30 [rfkill]
EAX: 00000000 EBX: e1eaeab4 ECX: f8947048 EDX: da8f5c00
ESI: e1eae1c0 EDI: e1eaeb78 EBP: d808ddac ESP: d808ddac
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rmmod (pid: 5618, ti=d808c000 task=f61a8410 task.ti=d808c000)
Stack:
d808ddcc f8902191 c02e4e10 ffffffff e1eaeb78 00000000 e1eae1c0 e1c0b360
d808de04 f856d62e e1c0b360 e1c0b4d8 e1c0b000 e1eae2b0 c02f500e 00000000
00000002 e1c0b6e0 e1c0b140 e1c0b000 f8586180 e1eae760 d808de20 c02e4df3
Call Trace:
[<f8902191>] ? ath9k_stop+0x81/0x120 [ath9k]
[<c02e4e10>] ? dev_close+0x90/0xd0
[<f856d62e>] ? ieee80211_stop+0x27e/0x5c0 [mac80211]
[<c02f500e>] ? dev_deactivate+0x17e/0x1a0
[<c02e4df3>] ? dev_close+0x73/0xd0
[<c02e4e97>] ? rollback_registered+0x47/0x210
[<c02e507e>] ? unregister_netdevice+0x1e/0x70
[<f856ceb9>] ? ieee80211_remove_interfaces+0x69/0xa0 [mac80211]
[<f8560190>] ? ieee80211_unregister_hw+0x40/0xe0 [mac80211]
[<f890438e>] ? ath_detach+0xbe/0x1e0 [ath9k]
[<f89044c0>] ? ath_cleanup+0x10/0x40 [ath9k]
[<f890bfa8>] ? ath_pci_remove+0x18/0x20 [ath9k]
[<c024867e>] ? pci_device_remove+0x1e/0x40
[<c02b4ec6>] ? __device_release_driver+0x56/0x90
[<c02b4f8f>] ? driver_detach+0x8f/0xa0
[<c02b40db>] ? bus_remove_driver+0x7b/0xb0
[<c02b54d9>] ? driver_unregister+0x39/0x40
[<c02488d5>] ? pci_unregister_driver+0x35/0x90
[<f890bec2>] ? ath_pci_exit+0x12/0x20 [ath9k]
[<f890d7e4>] ? ath9k_exit+0x10/0x3d [ath9k]
[<c036edcd>] ? mutex_unlock+0xd/0x10
[<c015d257>] ? sys_delete_module+0x167/0x210
[<c019c40b>] ? do_munmap+0x22b/0x280
[<c0103af0>] ? sysenter_do_call+0x12/0x2c
EIP: [<f8a52231>] rfkill_pause_polling+0x11/0x30 [rfkill] SS:ESP 0068:d808ddac

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e2c8649..5ee9800 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1288,9 +1288,6 @@ void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ath_deinit_rfkill(sc);
-#endif
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
@@ -1304,6 +1301,10 @@ void ath_detach(struct ath_softc *sc)
 		ieee80211_free_hw(aphy->hw);
 	}
 	ieee80211_unregister_hw(hw);
+
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+	ath_deinit_rfkill(sc);
+#endif
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 
-- 
1.6.0.4

