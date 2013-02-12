Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62729 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3BLV1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 16:27:13 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so667398wib.14
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 13:27:11 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 13 Feb 2013 02:56:51 +0530
Message-ID: <CABPxzY+g1gZGmXA=RuoXZY4LFXwkYN8VWKowr-oN_q3mad0w3w@mail.gmail.com> (sfid-20130212_222721_695993_10CF4A84)
Subject: [RFC] iwlwifi: Move updating of bssid under the association_changed
 flag to avoid crash
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BSSID from the BSS conf should be updated only when
there is a change in association information.

This was causing the crash in latest mac80211-next
when bringing the interface in monitor mode.
(Basically changing the bss_info).

Signed-off-by: Chaitanya <chaitanya.mgit@gmail.com>
---
Note1: Will fix the styling issues while submitting the patch.
Note2: For monitor mode the flag BSS_CHANGED_ASSOC
is not set.So its causing the crash.

Crash Information: Latest mac80211-next kernel.

 kernel: [  111.497436] BUG: unable to handle kernel NULL pointer
dereference at   (null)
 kernel: [  111.497523] IP: [<f921cb23>]
iwlagn_bss_info_changed+0x103/0x5a0 [iwldvm]
 kernel: [  111.497604] *pdpt = 0000000027f82001 *pde = 0000000000000000
 kernel: [  111.497664] Oops: 0000 [#1] SMP
 kernel: [  111.497704] Modules linked in: nfsd nfs_acl auth_rpcgss
nfs fscache lockd sunrpc rfcomm bnep binfmt_misc arc4 iwldvm
snd_hda_codec_hdmi mac80211 snd_hda_codec_idt i915 iwlwifi
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
cfg80211 btusb coretemp snd_seq_midi_event kvm_intel drm_kms_helper
snd_seq bluetooth snd_timer lib80211_crypt_tkip snd_seq_device drm
wl(PO) kvm snd dell_laptop psmouse soundcore aesni_intel dcdbas
ablk_helper dell_wmi cryptd snd_page_alloc lrw i2c_algo_bit aes_i586
lib80211 sparse_keymap serio_raw lpc_ich mei wmi xts ppdev gf128mul
parport_pc microcode video lp mac_hid parport tg3 sdhci_pci sdhci ptp
pps_core
 kernel: [  111.498452] Pid: 2530, comm: ifconfig Tainted: P
O 3.8.0-rc1+ #1 Dell Inc. Latitude E5430 non-vPro/0D3M0X
 kernel: [  111.498546] EIP: 0060:[<f921cb23>] EFLAGS: 00010206 CPU: 2
 kernel: [  111.498605] EIP is at iwlagn_bss_info_changed+0x103/0x5a0 [iwldvm]
 kernel: [  111.498661] EAX: 00000000 EBX: ea3edccc ECX: e75c66f8 EDX: 00000002
 kernel: [  111.498718] ESI: ea3ed2e0 EDI: e75c66f4 EBP: e757dd10 ESP: e757dcd0
 kernel: [  111.498775]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 kernel: [  111.498825] CR0: 80050033 CR2: 00000000 CR3: 27523000 CR4: 001407f0
 kernel: [  111.498882] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 kernel: [  111.498938] DR6: ffff0ff0 DR7: 00000400
 kernel: [  111.498975] Process ifconfig (pid: 2530, ti=e757c000
task=e7f1cc80 task.ti=e757c000)
 kernel: [  111.499043] Stack:
 kernel: [  111.499064]  e757dcec c1079c88 00000000 f57f80c0 efd38cc0
f57f80c0 f57f80c0 00000000
 kernel: [  111.499160]  00000000 ea3ed304 ea3ed2e8 e75c66f8 e741f200
f921ca20 e75c6000 e741f0c0
 kernel: [  111.499254]  e757dd44 f8aa379e 00004000 00000100 ea3eca68
ea3ec360 00000000 e75c66f8
 kernel: [  111.499348] Call Trace:
 kernel: [  111.499379]  [<c1079c88>] ? ttwu_do_wakeup+0x28/0x110
 kernel: [  111.499433]  [<f921ca20>] ? iwlagn_mac_config+0x3c0/0x3c0 [iwldvm]
 kernel: [  111.499506]  [<f8aa379e>]
ieee80211_bss_info_change_notify+0x9e/0x1b0 [mac80211]
 kernel: [  111.499599]  [<f8ac929c>]
ieee80211_vif_use_channel+0x29c/0x490 [mac80211]
 kernel: [  111.499682]  [<f8ab14d0>]
ieee80211_add_virtual_monitor.part.16+0x1c0/0x340 [mac80211]
 kernel: [  111.499760]  [<c14ddec5>] ? led_set_brightness+0x45/0x50
 kernel: [  111.499825]  [<f8ab271a>] ieee80211_do_open+0x80a/0xae0 [mac80211]
 kernel: [  111.499885]  [<c10711ee>] ? __raw_notifier_call_chain+0x1e/0x30
 kernel: [  111.499953]  [<f8aaffe0>] ?
ieee80211_check_concurrent_iface+0x20/0x1a0 [mac80211]
 kernel: [  111.500038]  [<f8ab2a4d>] ieee80211_open+0x5d/0x60 [mac80211]
 kernel: [  111.500095]  [<c1519af3>] __dev_open+0x83/0xf0
 kernel: [  111.500141]  [<c15f83f6>] ? _raw_spin_unlock_bh+0x16/0x20
 kernel: [  111.502636]  [<c1519a5e>] ? dev_set_rx_mode+0x2e/0x40
 kernel: [  111.505137]  [<c1519d91>] __dev_change_flags+0x81/0x160
 kernel: [  111.507634]  [<c1519f11>] dev_change_flags+0x21/0x60
 kernel: [  111.510145]  [<c1573539>] devinet_ioctl+0x539/0x680
 kernel: [  111.512652]  [<c12e5d41>] ? copy_to_user+0x41/0x60
 kernel: [  111.515143]  [<c1573ced>] inet_ioctl+0x8d/0xb0
 kernel: [  111.517624]  [<c1503519>] sock_ioctl+0x69/0x270
 kernel: [  111.520096]  [<c15034b0>] ? sock_fasync+0x90/0x90
 kernel: [  111.522557]  [<c1167f6a>] do_vfs_ioctl+0x7a/0x5a0
 kernel: [  111.525017]  [<c15fba27>] ? __do_page_fault+0x267/0x4b0
 kernel: [  111.527474]  [<c116216d>] ? final_putname+0x1d/0x40
 kernel: [  111.529931]  [<c1162314>] ? putname+0x24/0x40
 kernel: [  111.532379]  [<c1157ca5>] ? do_sys_open+0x155/0x1b0
 kernel: [  111.534777]  [<c11684fb>] sys_ioctl+0x6b/0x80
 kernel: [  111.537136]  [<c15ff68d>] sysenter_do_call+0x12/0x28
 kernel: [  111.539471] Code: 00 01 0f 84 b8 00 00 00 8b 43 72 8b 4d
ec 83 c8 08 89 43 72 80 79 0a 00 0f 85 b8 00 00 00 25 ff ff ff bf 89
43 72 8b 4d ec 8b 01 <8b> 10 89 53 5a 0f b7 40 04 66 89 43 5e 8b 07 89
c2 83 e2 fd 83
 kernel: [  111.544677] EIP: [<f921cb23>]
iwlagn_bss_info_changed+0x103/0x5a0 [iwldvm] SS:ESP 0068:e757dcd0
 kernel: [  111.547166] CR2: 0000000000000000
 kernel: [  111.564957] ---[ end trace a972af45bf5c52e9 ]---
: Kernel logging (proc) stopped.
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c
b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 9fabd26..b173497 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1490,7 +1490,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;

-	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);

 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) { @@ -1534,6 +1533,7 @@ void
iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		/* Enable RX differential gain and sensitivity calibrations */
 		iwlagn_chain_noise_reset(priv);
 		priv->start_calib = 1;
+		memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 	}

 	if (changes & BSS_CHANGED_IBSS) {
