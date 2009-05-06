Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZEFHLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 03:11:10 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix bug when last_request is not set on freq_reg_info_regd()
Date: Wed,  6 May 2009 03:11:08 -0400
Message-Id: <1241593868-10098-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the custom regulatory domain API its possible for last_request
to be NULL. This fixes this oops:

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<f8eb9c50>] :cfg80211:freq_reg_info_regd+0x24/0x121
*pdpt = 0000000036590001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/platform/dcdbas/smi_data_buf_phys_addr
Modules linked in: ath9k(N+) mac80211(N) cfg80211(N) (ETC)
Supported: No

Pid: 26324, comm: modprobe Tainted: G          (2.6.27.19-5-pae #1)
EIP: 0060:[<f8eb9c50>] EFLAGS: 00210286 CPU: 1
EIP is at freq_reg_info_regd+0x24/0x121 [cfg80211]
EAX: 00000000 EBX: f544e060 ECX: f7dddd94 EDX: 0024cde0
ESI: f8f4c43c EDI: 00000000 EBP: 00000000 ESP: f7dddd44
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 26324, ti=f7ddc000 task=f3ca0370 task.ti=f7ddc000)
Stack: c0505300 f544eb54 f7dddd94 0024cde0 f8f343ba f8f593c8 f544e060 00000000
       00000000 f8eba025 f7dddd90 f8f4c43c 00000000 00000004 00000f40 f8f4c43c
       f544e060 f544f2d4 00000000 00000000 00000000 f544f590 f544eb54 f544f329
Call Trace:
 [<f8eba025>] wiphy_apply_custom_regulatory+0xb1/0x14e [cfg80211]
 [<f8f337a4>] ath_attach+0x707/0x9ed [ath9k]
 [<f8f39f36>] ath_pci_probe+0x18d/0x29a [ath9k]
 [<c023c7ba>] pci_device_probe+0xa3/0xe4
 [<c02a860b>] really_probe+0xd7/0x1de
 [<c02a87e7>] __driver_attach+0x37/0x55
 [<c02a7eed>] bus_for_each_dev+0x31/0x57
 [<c02a83bd>] driver_attach+0x16/0x18
 [<c02a78e6>] bus_add_driver+0xec/0x21b
 [<c02a8959>] driver_register+0x85/0xe2
 [<c023c9bb>] __pci_register_driver+0x3c/0x69
 [<f8e8f043>] ath9k_init+0x43/0x68 [ath9k]
 [<c010112b>] _stext+0x3b/0x116
 [<c014a872>] sys_init_module+0x8a/0x19e
 [<c01049ad>] sysenter_do_call+0x12/0x21
 [<ffffe430>] 0xffffe430
 =======================
Code: 0f 94 c0 c3 31 c0 c3 55 57 56 53 89 c3 83 ec 14 8b 74 24 2c 89 54 24 0c 89 4c 24 08 85 f6 75 06 8b 35 28 6c ec f8 a1 2c 6c ec f8 <8b> 40 04 83 f8 03 74 3a 48 74 37 8b 43 28 85 c0 74 30 89 c6 8b
EIP: [<f8eb9c50>] freq_reg_info_regd+0x24/0x121 [cfg80211] SS:ESP 0068:f7dddd44

Cc: stable@kernel.org
Reported-by: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Forgot to cc stable

 net/wireless/reg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 48db569..0d07913 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -860,7 +860,8 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	 * Follow the driver's regulatory domain, if present, unless a country
 	 * IE has been processed or a user wants to help complaince further
 	 */
-	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	if (last_request &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
 	    wiphy->regd)
 		regd = wiphy->regd;
-- 
1.5.6.4

