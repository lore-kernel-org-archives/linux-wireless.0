Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:43084 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab1BLDdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 22:33:33 -0500
From: =?gb2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>
To: 'Stanislaw Gruszka' <sgruszka@redhat.com>
CC: 'Johannes Berg' <johannes@sipsolutions.net>,
	'Larry Finger' <Larry.Finger@lwfinger.net>,
	'John W Linville' <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	=?gb2312?B?J7frtLrR4Cc=?= <amyfcy_feng@realsil.com.cn>,
	=?gb2312?B?J9DcueKwsic=?= <guangan_xiong@realsil.com.cn>
References: <20110207151209.GG2319@redhat.com> <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn> <20110209105405.GB5528@redhat.com> <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn> <20110210074140.GA2228@redhat.com> <39A39FA0AD1A481480DE0BD469AAA79E@realsil.com.cn> <20110210095006.GB2228@redhat.com> <86D43C3FD69641C38E7144E721BCC5A6@realsil.com.cn> <20110210113715.GA31839@redhat.com> <3734EB1DAE3E49A1867FDE1C680A296D@realsil.com.cn> <20110211102213.GA2231@redhat.com>
Subject: [RFC] mac80211: mac80211's null packet issue.
Date: Sat, 12 Feb 2011 11:32:52 +0800
Message-ID: <7F13009C7E784222BE71FAE478584C5D@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
In-Reply-To: <20110211102213.GA2231@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Stanislaw & John:

follwing is the Call Trace issue I found:

====================
Feb 12 10:58:28 lzm-laptop kernel: [243855.472129]
rtl8192de-0:rtl92d_phy_switch_wirelessband():<0-0> ====>2.4G
Feb 12 10:58:28 lzm-laptop kernel: [243855.475867] pm = 0 null have been
send
Feb 12 10:58:29 lzm-laptop kernel: [243855.672881] pm = 1 null have been
send
Feb 12 10:58:29 lzm-laptop kernel: [243855.733668] =========> rtl_op_config
wide_chan:56
Feb 12 10:58:29 lzm-laptop kernel: [243855.733741]
rtl8192de-0:rtl92d_phy_switch_wirelessband():<0-0> ====>5G
Feb 12 10:58:30 lzm-laptop kernel: [243856.621680] =========> rtl_op_config
wide_chan:149
Feb 12 10:58:30 lzm-laptop kernel: [243856.621754]
rtl8192de-0:rtl92d_phy_switch_wirelessband():<0-0> ====>5G
Feb 12 10:58:30 lzm-laptop kernel: [243856.660040] ------------[ cut here
]------------
Feb 12 10:58:30 lzm-laptop kernel: [243856.660067] WARNING: at
/home/mac80211_2.6.37/tx.c:656 invoke_tx_handlers+0xd46/0xf80 [mac80211]()
Feb 12 10:58:30 lzm-laptop kernel: [243856.660072] Hardware name: A8Sc

Feb 12 10:58:30 lzm-laptop kernel: [243856.660077] wlan0: Dropped data frame
as no usable bitrate found while scanning and associated. Target station:
00:1c:f0:c0:ab:bd on 5 GHz band
Feb 12 10:58:30 lzm-laptop kernel: [243856.660081] Modules linked in:
rtl8192de rtl8192se rtl8192ce rtlwifi mac80211 cfg80211 nls_iso8859_1
nls_cp437 vfat fat usb_storage aes_i586 aes_generic arc4 binfmt_misc rfcomm
ppdev sco bridge stp bnep l2cap snd_hda_codec_si3054 snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep joydev snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device nouveau ttm
drm_kms_helper drm snd intel_agp i2c_algo_bit asus_laptop sparse_keymap
intel_gtt agpgart uvcvideo psmouse videodev r852 serio_raw video btusb
soundcore snd_page_alloc output v4l1_compat irda crc_ccitt sm_common nand
nand_ids nand_ecc sdhci_pci sdhci mtd led_class bluetooth lp parport ahci
r8169 libahci mii [last unloaded: mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660195] Pid: 5873, comm:
kworker/u:2 Tainted: G        W   2.6.37-020637rc1-generic #201011020905
Feb 12 10:58:30 lzm-laptop kernel: [243856.660199] Call Trace:
Feb 12 10:58:30 lzm-laptop kernel: [243856.660220]  [<fbff21a6>] ?
invoke_tx_handlers+0xd46/0xf80 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660241]  [<fbff21a6>] ?
invoke_tx_handlers+0xd46/0xf80 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660252]  [<c014f7c1>]
warn_slowpath_common+0x81/0xa0
Feb 12 10:58:30 lzm-laptop kernel: [243856.660272]  [<fbff21a6>] ?
invoke_tx_handlers+0xd46/0xf80 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660282]  [<c014f883>]
warn_slowpath_fmt+0x33/0x40
Feb 12 10:58:30 lzm-laptop kernel: [243856.660294]  [<fbff21a6>]
invoke_tx_handlers+0xd46/0xf80 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660307]  [<fbff2440>]
ieee80211_tx+0x60/0x1b0 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660312]  [<c0505766>] ?
pskb_expand_head+0x56/0x1b0
Feb 12 10:58:30 lzm-laptop kernel: [243856.660315]  [<c05058ac>] ?
pskb_expand_head+0x19c/0x1b0
Feb 12 10:58:30 lzm-laptop kernel: [243856.660328]  [<fbff2638>]
ieee80211_xmit+0xa8/0x1f0 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660332]  [<c0505177>] ?
__alloc_skb+0x77/0x100
Feb 12 10:58:30 lzm-laptop kernel: [243856.660344]  [<fbff0c9d>] ?
ieee80211_nullfunc_get+0x5d/0x140 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660356]  [<fbff27c5>]
ieee80211_tx_skb+0x45/0x60 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660367]  [<fbfe299f>]
ieee80211_send_nullfunc+0x3f/0x60 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660377]  [<fbfe2a49>]
ieee80211_dynamic_ps_enable_work+0x89/0x90 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660383]  [<c0168819>]
process_one_work+0xd9/0x330
Feb 12 10:58:30 lzm-laptop kernel: [243856.660393]  [<fbfe29c0>] ?
ieee80211_dynamic_ps_enable_work+0x0/0x90 [mac80211]
Feb 12 10:58:30 lzm-laptop kernel: [243856.660397]  [<c0169413>]
worker_thread+0xb3/0x210
Feb 12 10:58:30 lzm-laptop kernel: [243856.660401]  [<c0169360>] ?
worker_thread+0x0/0x210
Feb 12 10:58:30 lzm-laptop kernel: [243856.660405]  [<c016c935>]
kthread+0x75/0x80
Feb 12 10:58:30 lzm-laptop kernel: [243856.660409]  [<c016c8c0>] ?
kthread+0x0/0x80
Feb 12 10:58:30 lzm-laptop kernel: [243856.660413]  [<c01032fe>]
kernel_thread_helper+0x6/0x10
Feb 12 10:58:30 lzm-laptop kernel: [243856.660415] ---[ end trace
31d359aae6ce5643 ]---
Feb 12 10:58:30 lzm-laptop kernel: [243856.660419] ===========> rtl_get_rate
rix:0 isnull:1 ps_flag:1
Feb 12 10:58:30 lzm-laptop kernel: [243856.660421] rtlwifi: 
Feb 12 10:58:30 lzm-laptop kernel: [243856.660423] In process "kworker/u:2"
(pid 5873):skb 
Feb 12 10:58:30 lzm-laptop kernel: [243856.660426] 48 11 00 00  00 1C F0 C0
AB BD 00 E0  4C 92 01 BA  
Feb 12 10:58:30 lzm-laptop kernel: [243856.660437] 00 1C F0 C0  AB BD 00 00

Feb 12 10:58:30 lzm-laptop kernel: [243856.660443] 
Feb 12 10:58:30 lzm-laptop kernel: [243856.660512] pm = 1 null have been
send
Feb 12 10:58:30 lzm-laptop kernel: [243856.797670] =========> rtl_op_config
wide_chan:9
Feb 12 10:58:30 lzm-laptop kernel: [243856.797744]
rtl8192de-0:rtl92d_phy_switch_wirelessband():<0-0> ====>2.4G
Feb 12 10:58:30 lzm-laptop kernel: [243856.801563] pm = 0 null have been
send
Feb 12 10:58:30 lzm-laptop kernel: [243856.900126] pm = 1 null have been
send
Feb 12 10:58:30 lzm-laptop kernel: [243857.000119] pm = 1 null have been
send
Feb 12 10:58:30 lzm-laptop kernel: [243857.061661] =========> rtl_op_config
wide_chan:153
====================

I find the root cause is: after I linked AP in 9 channel(2.4G), I use iwlist
wlan0 scan
when driverf offchannel to 5G 149 channel, a null(pm=1) packet was send ,
and then call trace
happend because "WARN" in "ieee80211_tx_h_rate_ctrl" .
Below are corresponding code:
ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
{
	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
	

	/*
	 * Lets not bother rate control if we're associated and cannot
	 * talk to the sta. This should not happen (but this indeed
happend).
	 */
	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
		 (sta_flags & WLAN_STA_ASSOC) &&
		 !rate_usable_index_exists(sband, &tx->sta->sta),
		 "%s: Dropped data frame as no usable bitrate found while "
		 "scanning and associated. Target station: "
		 "%pM on %d GHz band\n",
		 tx->sdata->name, hdr->addr1,
		 tx->channel->band ? 5 : 2))
		return TX_DROP;

}

And I also find this issue happens when I open power save:
	hw->flags = IEEE80211_HW_SIGNAL_DBM |
	    IEEE80211_HW_RX_INCLUDES_FCS |
	    IEEE80211_HW_BEACON_FILTER |
	    IEEE80211_HW_AMPDU_AGGREGATION |
	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 
	    IEEE80211_HW_SUPPORTS_PS |
	    IEEE80211_HW_PS_NULLFUNC_STACK |
	    /* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
	   0;
if I close power save like follwing this issue will never happen:
	hw->flags = IEEE80211_HW_SIGNAL_DBM |
	    IEEE80211_HW_RX_INCLUDES_FCS |
	    IEEE80211_HW_BEACON_FILTER |
	    IEEE80211_HW_AMPDU_AGGREGATION |
	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 
	    /* IEEE80211_HW_SUPPORTS_PS | */
	    /* IEEE80211_HW_PS_NULLFUNC_STACK | */
	    /* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
	   0;

So, is any body familiar with mac80211 power save can help ?
Thank you!

lizhaoming
--

