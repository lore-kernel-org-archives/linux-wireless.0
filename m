Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:59201 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab3DGWDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:03:17 -0400
Date: Sun, 7 Apr 2013 15:03:15 -0700
From: Jonathan McDowell <noodles@earth.li>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [Ilw] Problems with Intel 2230 and AP mode
Message-ID: <20130407220314.GX31591@earth.li> (sfid-20130408_000322_716770_597992FC)
References: <20130402190831.GQ31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301965EC0@HASMSX103.ger.corp.intel.com>
 <20130403182153.GT31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301969684@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301969684@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 07, 2013 at 07:23:17AM +0000, Grumbach, Emmanuel wrote:
> > On Tue, Apr 02, 2013 at 07:11:12PM +0000, Grumbach, Emmanuel wrote:
> > > >
> > > > I'm trying to build my own wifi router, cobbling together a Debian
> > > > (wheezy) box, hostapd (1.0) and an Intel 2230. I'm seeing various
> > > > problems with the 2230 and I'm wondering if I'm mad for trying to use
> > > > this card in AP mode (in which case is there an alternative Intel card I
> > > > should use, or is an ath9k my best bet), or if it's worthwhile reporting
> > > > the issues and trying fixes.
> > > >
> > > > I'm using 3.8.5 (and previously 3.8.4). I tried 3.9-rc4 briefly but it
> > > > was unusable - as soon as there was any traffic I saw errors like:
...
> Can you please try the patch attached?
>
> Note that I couldn't really test it so...
>
> Also, it seems that the best way to reproduce the issue is to have a
> station disappear while TX AMPDU is working.

I suspect that's being caused by the cell phones appearing briefly and
then disappearing. I've applied the patch to 3.9-rc5 (and also "iwlwifi:
dvm: don't send HCMD in restart flow" which I saw hit stable but isn't
in rc5) and I've had the following WARNING:

[ 8370.590990] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: ssn = next_recl = 2026
[ 8370.593327] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 11 on FIFO 4 WrPtr: 234
[ 8372.504646] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: ssn = next_recl = 700
[ 8372.526891] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 12 on FIFO 4 WrPtr: 188
[ 8381.218880] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 2028
[ 8381.218912] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactivate queue 11
[ 8385.219756] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 708
[ 8385.219788] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactivate queue 12
[ 8421.657189] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: ssn = next_recl = 196
[ 8422.646042] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_flush Flush AGG: sta 4 tid 0 q 11 state 0
[ 8422.646301] ------------[ cut here ]------------
[ 8422.647227] WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1120 iwl_trans_pcie_txq_disable+0x45/0xb9 [iwlwifi]()
[ 8422.648165] Hardware name: To be filled by O.E.M.
[ 8422.649125] queue 11 not used
[ 8422.649150] Modules linked in: sit tunnel4 ip6t_REJECT xt_LOG xt_limit nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 8021q garp stp llc ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables dummy nls_utf8 nls_cp437 vfat fat loop rt2800usb rt2800lib rt2x00usb rt2x00lib crc_ccitt tda18271 lgdt3305 hid_generic em28xx_dvb dvb_core btusb bluetooth em28xx videobuf2_vmalloc videobuf2_memops videobuf2_core tveeprom v4l2_common videodev media joydev hid_aureal usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm arc4 snd_page_alloc kvm_intel iwldvm mac80211 iwlwifi kvm snd_seq crc32_pclmul crc32c_intel ghash_clmulni_intel snd_seq_device snd_timer xhci_hcd snd cfg80211 rfkill iTCO_wdt iTCO_vendor_support cryptd soundcore i2c_i801 lpc_ich mfd_core mei ehci_pci ehci_hcd usbcore usb_common acpi_cpufreq mperf processor evdev microcode fan thermal
[ 8422.657942] Pid: 2038, comm: hostapd Not tainted 3.9.0-rc5 #2
[ 8422.659702] Call Trace:
[ 8422.661460]  [<ffffffff8102c007>] ? warn_slowpath_common+0x76/0x8c
[ 8422.663291]  [<ffffffff8102c0b5>] ? warn_slowpath_fmt+0x45/0x4a
[ 8422.665130]  [<ffffffffa024396f>] ? iwlagn_txfifo_flush+0x9d/0xa3 [iwldvm]
[ 8422.667003]  [<ffffffffa032d92d>] ? iwl_trans_pcie_txq_disable+0x45/0xb9 [iwlwifi]
[ 8422.668911]  [<ffffffffa0241913>] ? iwlagn_tx_agg_flush+0xc4/0xd9 [iwldvm]
[ 8422.670820]  [<ffffffffa023e82d>] ? iwlagn_mac_ampdu_action+0x1cb/0x2db [iwldvm]
[ 8422.672754]  [<ffffffffa01be4ae>] ? drv_ampdu_action+0xf2/0x148 [mac80211]
[ 8422.674706]  [<ffffffff8107ede1>] ? try_stop_cpus+0x42/0x53
[ 8422.676671]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
[ 8422.678687]  [<ffffffffa01bef01>] ? ___ieee80211_stop_tx_ba_session+0x1b3/0x1db [mac80211]
[ 8422.680739]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
[ 8422.682822]  [<ffffffffa01bf30a>] ? __ieee80211_stop_tx_ba_session+0x31/0x4a [mac80211]
[ 8422.684964]  [<ffffffffa01bdf68>] ? ieee80211_sta_tear_down_BA_sessions+0x2d/0x58 [mac80211]
[ 8422.687157]  [<ffffffffa01ba1d3>] ? __sta_info_destroy+0x41/0x1e2 [mac80211]
[ 8422.689368]  [<ffffffffa01ba4de>] ? sta_info_destroy_addr_bss+0x35/0x56 [mac80211]
[ 8422.691633]  [<ffffffffa00baa8b>] ? nl80211_del_station+0x6c/0xc2 [cfg80211]
[ 8422.693915]  [<ffffffff81386476>] ? genl_rcv_msg+0x1b6/0x1ff
[ 8422.696219]  [<ffffffff813862c0>] ? genl_rcv+0x28/0x28
[ 8422.698532]  [<ffffffff81385f83>] ? netlink_rcv_skb+0x36/0x7c
[ 8422.700808]  [<ffffffff813862b7>] ? genl_rcv+0x1f/0x28
[ 8422.703115]  [<ffffffff81385aa5>] ? netlink_unicast+0xde/0x15e
[ 8422.705447]  [<ffffffff810f6f5f>] ? set_restore_sigmask+0x2d/0x2d
[ 8422.707796]  [<ffffffff81385db2>] ? netlink_sendmsg+0x28d/0x2b4
[ 8422.710111]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
[ 8422.712466]  [<ffffffff81354616>] ? sock_sendmsg+0x4f/0x6c
[ 8422.714770]  [<ffffffff814044ab>] ? packet_recvmsg+0x469/0x47c
[ 8422.717095]  [<ffffffff810f6f5f>] ? set_restore_sigmask+0x2d/0x2d
[ 8422.719447]  [<ffffffff81354825>] ? __sys_sendmsg+0x1f2/0x284
[ 8422.721801]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
[ 8422.724180]  [<ffffffff8141dc07>] ? _cond_resched+0x6/0x1a
[ 8422.726589]  [<ffffffff810468cc>] ? autoremove_wake_function+0x2a/0x2a
[ 8422.729015]  [<ffffffff810f93cc>] ? dentry_kill+0x121/0x12d
[ 8422.731459]  [<ffffffff810f981d>] ? dput+0xe6/0xf3
[ 8422.733909]  [<ffffffff810ea73f>] ? __fput+0x192/0x1b9
[ 8422.736418]  [<ffffffff810fdac0>] ? fget_light+0x2c/0x74
[ 8422.739611]  [<ffffffff8135584c>] ? sys_sendmsg+0x39/0x57
[ 8422.742841]  [<ffffffff81423852>] ? system_call_fastpath+0x16/0x1b
[ 8422.746075] ---[ end trace dc0022bd7c6404b6 ]---
[ 8427.736757] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: ssn = next_recl = 734
[ 8427.744108] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 11 on FIFO 4 WrPtr: 222
[ 8457.809811] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ssn = next_recl = 1595
[ 8457.809843] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactivate queue 11
[ 8487.759858] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can't proceed: ssn 1843, next_reclaimed = 1803
[ 8487.786678] iwlwifi 0000:04:00.0: I iwlagn_check_ratid_empty Can continue ADDBA flow ssn = next_recl = 1843
[ 8487.802696] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate queue 11 on FIFO 4 WrPtr: 51

Didn't seem to cause any actual issues - wifi has stayed up.

J.

-- 
Be Ye Not Lost Among Precepts of Order
