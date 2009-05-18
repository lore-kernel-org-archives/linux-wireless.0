Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZERQ1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 12:27:35 -0400
Subject: Re: 2.6.29.3: iwlwifi WARNING
From: reinette chatre <reinette.chatre@intel.com>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A0D0E36.3010304@nets.rwth-aachen.de>
References: <4A0D0E36.3010304@nets.rwth-aachen.de>
Content-Type: text/plain
Date: Mon, 18 May 2009 09:34:14 -0700
Message-Id: <1242664454.32358.527.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

On Thu, 2009-05-14 at 23:39 -0700, Arnd Hannemann wrote:
> Hi,
> 
> I'm using ubuntu jaunty with 2.6.29.3 mainline build:
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.29.3/
> 
> And from time to time get this:
> 
> [98439.060208] ------------[ cut here ]------------
> [98439.060217] WARNING: at
> /home/kernel-ppa/mainline/build/drivers/net/wireless/iwlwifi/iwl-sta.c:728
> iwl_set_tkip_dynamic_key_info+0xc0/0xd0 [iwlcore]()
> [98439.060224] Hardware name: 20552PG
> [98439.060228] no space for new kewModules linked in: nls_iso8859_1
> nls_cp437 vfat fat usb_storage binfmt_misc i915 drm i2c_algo_bit ppdev
> bnep ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack ipt_
> REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel
> kvm sbp2 lp parport snd_hda_codec_conexant joydev snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi sn
> d_seq_midi_event arc4 ecb snd_seq snd_timer snd_seq_device iwlagn
> iwlcore snd mac80211 soundcore thinkpad_acpi pcmcia sdhci_pci sdhci
> psmouse iTCO_wdt video intel_agp agpgart snd_page_alloc pcspkr nvram
> yenta_socket rsrc_nonstatic pcmcia
> _core ricoh_mmc led_class iTCO_vendor_support serio_raw btusb output
> cfg80211 sha256_generic aes_i586 aes_generic cbc ohci1394 ieee1394
> e1000e dm_crypt
> [98439.060372] Pid: 10, comm: events/0 Not tainted
> 2.6.29-02062903-generic #02062903
> [98439.060377] Call Trace:
> [98439.060394]  [<c013a636>] warn_slowpath+0x86/0xa0
> [98439.060409]  [<c04f7938>] ? _spin_lock+0x8/0x10
> [98439.060418]  [<c01e967c>] ? inotify_d_instantiate+0x3c/0x50
> [98439.060427]  [<c028879c>] ? security_d_instantiate+0x1c/0x20
> [98439.060436]  [<c01cebf8>] ? d_instantiate+0x38/0x40
> [98439.060444]  [<c01cf3c7>] ? dput+0x67/0xd0
> [98439.060453]  [<c01220f8>] ? default_spin_lock_flags+0x8/0x10
> [98439.060460]  [<c04f78e2>] ? _spin_lock_irqsave+0x32/0x50
> [98439.060489]  [<f80ea900>] iwl_set_tkip_dynamic_key_info+0xc0/0xd0
> [iwlcore]
> [98439.060523]  [<f80eac5f>] iwl_set_dynamic_key+0x5f/0x80 [iwlcore]
> [98439.060546]  [<f81a5793>] iwl_mac_set_key+0xf3/0x120 [iwlagn]
> [98439.060565]  [<f81a56a0>] ? iwl_mac_set_key+0x0/0x120 [iwlagn]
> [98439.060606]  [<f8097fd3>] ieee80211_key_enable_hw_accel+0x53/0xc0
> [mac80211]
> [98439.060622]  [<c027a9fc>] ? debugfs_remove+0x4c/0x60
> [98439.060665]  [<f8098168>] __ieee80211_key_todo+0xe8/0x130 [mac80211]
> [98439.060674]  [<c04f6044>] ? schedule+0x2f4/0x570
> [98439.060681]  [<c04f69eb>] ? mutex_lock+0xb/0x20
> [98439.060727]  [<f80982cd>] ieee80211_key_todo+0xd/0x20 [mac80211]
> [98439.060767]  [<f8098368>] key_todo+0x8/0x10 [mac80211]
> [98439.060775]  [<c014b344>] run_workqueue+0xd4/0x170
> [98439.060815]  [<f8098360>] ? key_todo+0x0/0x10 [mac80211]
> [98439.060824]  [<c014bd28>] worker_thread+0x88/0xe0
> [98439.060832]  [<c014ede0>] ? autoremove_wake_function+0x0/0x40
> [98439.060840]  [<c014bca0>] ? worker_thread+0x0/0xe0
> [98439.060846]  [<c014ea72>] kthread+0x42/0x70
> [98439.060852]  [<c014ea30>] ? kthread+0x0/0x70
> [98439.060860]  [<c0103da7>] kernel_thread_helper+0x7/0x10
> [98439.060865] ---[ end trace 3b8aa73681896774 ]---
> [102020.364126] iwlagn: Removing wrong key 1 0x410b
> [102020.364274] ------------[ cut here ]------------
> 
> and then this very same message spams my dmesg.
> Computer is a Lenovo T500 with Core2Duo.
> 


Could you please try this patch? It can be found in 2.6.30 and applies
with some fuzz to 2.6.29. If it works for you then we can look into
backporting it to 2.6.29.

>From 299f5462087f3bc2141e6bc83ba7e2b15d8a07d2 Mon Sep 17 00:00:00 2001
From: Reinette Chatre <reinette.chatre@intel.com>
Date: Thu, 30 Apr 2009 13:56:31 -0700
Subject: [PATCH] iwlwifi: update key flags at time key is set

We need to be symmetrical in what is done when key is set and cleared.
This is important wrt the key flags as they are used during key
clearing and if they are not set when the key is set the key cannot be
cleared completely.

This addresses the many occurences of the WARN found in
iwl_set_tkip_dynamic_key_info() and tracked in
http://www.kerneloops.org/searchweek.php?search=iwl_set_dynamic_key

If calling iwl_set_tkip_dynamic_key_info()/iwl_remove_dynamic_key()
pair a few times in a row will cause that we run out of key space.
This is because the index stored in the key flags is used by
iwl_remove_dynamic_key() to decide if it should remove the key.
Unfortunately the key flags, and hence the key index is currently only
set at the time the key is written to the device (in
iwl_update_tkip_key()) and _not_ in iwl_set_tkip_dynamic_key_info().
Fix this by setting flags in iwl_set_tkip_dynamic_key_info().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5798fe4..44ab03a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -719,6 +719,14 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	int ret = 0;
+	__le16 key_flags = 0;
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
@@ -738,6 +746,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for a new key");
 
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -754,9 +765,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 {
 	u8 sta_id = IWL_INVALID_STATION;
 	unsigned long flags;
-	__le16 key_flags = 0;
 	int i;
-	DECLARE_MAC_BUF(mac);
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -771,16 +780,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 		return;
 	}
 
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == priv->hw_params.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
 
 	for (i = 0; i < 5; i++)
-- 
1.5.6.3



