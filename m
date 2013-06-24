Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12664 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3FXNTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:19:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.9 4/4] iwlwifi: mvm: reduce the number of supported interfaces
Date: Mon, 24 Jun 2013 16:19:05 +0300
Message-Id: <1372079945-7445-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130624_152234_943357_C7413608)
In-Reply-To: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver in 3.9 can't support more than one interface
concurrently. The parameters given to cfg80211 were wrong.
Next versions are fixed by allowing concurrent interfaces.
This is why you won't see this patch upstream.

This patches fixes:

[   76.711244] WARNING: at net/wireless/core.c:481 wiphy_register+0x646/0x710 [cfg80211]()
[   76.711246] Hardware name: Latitude E6410
[   76.711247] Modules linked in: iwlmvm(+) mac80211 iwlwifi cfg80211 i915 snd_hda_codec_hdmi binfmt_misc snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep coretemp snd_pcm kvm_intel kvm snd_seq_midi drm_kms_helper joydev snd_rawmidi drm snd_seq_midi_event snd_seq ghash_clmulni_intel snd_timer aesni_intel snd_seq_device ablk_helper snd cryptd lrw aes_x86_64 xts psmouse gf128mul dell_laptop microcode dcdbas dell_wmi soundcore sparse_keymap serio_raw snd_page_alloc i2c_algo_bit lpc_ich video wmi firewire_ohci firewire_core sdhci_pci crc_itu_t sdhci e1000e ptp pps_core
[   76.711303] Pid: 2533, comm: modprobe Not tainted 3.9.7+ #2
[   76.711304] Call Trace:
[   76.711310]  [<ffffffff81060faf>] warn_slowpath_common+0x7f/0xc0
[   76.711313]  [<ffffffff8106100a>] warn_slowpath_null+0x1a/0x20
[   76.711321]  [<ffffffffa0460726>] wiphy_register+0x646/0x710 [cfg80211]
[   76.711327]  [<ffffffff811b9fb0>] ? __kmalloc+0x140/0x2c0
[   76.711344]  [<ffffffffa04f3505>] ? ieee80211_register_hw+0x1a5/0x840 [mac80211]
[   76.711351]  [<ffffffffa04f36eb>] ieee80211_register_hw+0x38b/0x840 [mac80211]
[   76.711359]  [<ffffffffa0402a55>] iwl_mvm_mac_setup_register+0x235/0x260 [iwlmvm]
[   76.711365]  [<ffffffffa0403bbc>] iwl_op_mode_mvm_start+0x3dc/0x4d0 [iwlmvm]
[   76.711373]  [<ffffffffa03ce11c>] iwl_opmode_register+0xcc/0xf0 [iwlwifi]
[   76.711378]  [<ffffffffa02cb000>] ? 0xffffffffa02cafff
[   76.711383]  [<ffffffffa02cb036>] iwl_mvm_init+0x36/0x1000 [iwlmvm]
[   76.711388]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[   76.711393]  [<ffffffff810e4c3b>] load_module+0x127b/0x1c50
[   76.711397]  [<ffffffff8139d110>] ? ddebug_proc_open+0xd0/0xd0
[   76.711404]  [<ffffffff81388e7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   76.711407]  [<ffffffff810e56e7>] sys_init_module+0xd7/0x120
[   76.711413]  [<ffffffff81759d19>] system_call_fastpath+0x16/0x1b
[   76.711415] ---[ end trace e19789dfc0454b26 ]---

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8572358..b048fd3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -78,7 +78,7 @@
 
 static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 	{
-		.max = 1,
+		.max = 2,
 		.types = BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP),
 	},
@@ -87,7 +87,7 @@ static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
 	{
 		.num_different_channels = 1,
-		.max_interfaces = 3,
+		.max_interfaces = 2,
 		.limits = iwl_mvm_limits,
 		.n_limits = ARRAY_SIZE(iwl_mvm_limits),
 	},
-- 
1.7.10.4

