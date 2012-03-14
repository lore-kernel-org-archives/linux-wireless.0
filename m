Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2CNG4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 02:56:50 -0400
Date: Wed, 14 Mar 2012 07:25:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
Message-ID: <20120314062549.GA2788@redhat.com> (sfid-20120314_075701_739884_DD4ED5BF)
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331651730.3329.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 04:15:30PM +0100, Johannes Berg wrote:
> On Tue, 2012-03-13 at 16:10 +0100, Stanislaw Gruszka wrote:
> > ctx->vif is dereferenced in different part of iwlwifi code, so do not
> > nullify it.
> > 
> > This should address at least one of the possible reasons of WARNING at
> > iwlagn_mac_remove_interface, and perhaps some random crashes when
> > firmware reset is performed.
> 
> I'm not completely convinced --
Me too :-)

> there are parts of the driver that are
> active even when no interface has ever been added.

Yes, sometimes vif is checked and behaviour is different when it is
NULL. I'm not sure how about iwlwifi, because I did not analyse all of
ctx->vif usage, but on iwlegacy we have code which do not check vif
against NULL or do check, but this is not synchronized by il->mutex.

> Have you seen crashes due to this? I have seen the warning in the past
> but in some recent firmware reset testing I never ran into it again...

I have vif == NULL crashes reports on old RHEL6, that _possibly_ are
caused by this issue, but I'm not 100% sure, RHEL6 include own vif related
changes needed by backport.

I'm not able to reproduce vif crashes on force_reset on current
wireless-testing, but when I transmit data and trigger a reset,
device stops working. There are some messages [1] (20:00.0 is 6300
adapter, but on others I tested 5300 and 100 reset does not work too).

So hw reset is completely broken at present, perhaps is time to remove
watchdog and related infrastructure.

Stanislaw

[1]

[  973.242040] iwlwifi 0000:a0:00.0: On demand firmware reload
[  973.242130] iwlwifi 0000:40:00.0: On demand firmware reload
[  973.242317] iwlwifi 0000:20:00.0: On demand firmware reload
[  973.242571] ieee80211 phy0: Hardware restart was requested
[  973.249575] ieee80211 phy2: Hardware restart was requested
[  973.249638] iwlwifi 0000:a0:00.0: L1 Disabled; Enabling L0S
[  973.249755] ieee80211 phy1: Hardware restart was requested
[  973.252883] iwlwifi 0000:a0:00.0: Radio type=0x0-0x2-0x0
[  973.305621] iwlwifi 0000:40:00.0: L1 Disabled; Enabling L0S
[  973.368360] wlan18: dropped data frame to not associated station 00:00:00:00:00:00
[  973.368467] iwlwifi 0000:20:00.0: L1 Disabled; Enabling L0S
[  973.375227] iwlwifi 0000:20:00.0: Radio type=0x0-0x3-0x1
[  975.467038] iwlwifi 0000:20:00.0: Error sending REPLY_TX_LINK_QUALITY_CMD: time out after 2000ms.
[  975.467043] iwlwifi 0000:20:00.0: Current CMD queue read_ptr 11 write_ptr 12
[  975.943046] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  975.943050] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 13
[  975.949740] iwlwifi 0000:20:00.0: Current HW read_ptr 13 write_ptr 13
[  976.450021] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  976.450026] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 13
[  976.456709] iwlwifi 0000:20:00.0: Current HW read_ptr 13 write_ptr 13
[  976.957012] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  976.957016] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 13
[  976.963689] iwlwifi 0000:20:00.0: Current HW read_ptr 13 write_ptr 13
[  977.464014] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  977.464020] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 13
[  977.470701] iwlwifi 0000:20:00.0: Current HW read_ptr 13 write_ptr 13
[  977.471024] iwlwifi 0000:20:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after 2000ms.
[  977.471028] iwlwifi 0000:20:00.0: Current CMD queue read_ptr 11 write_ptr 13
[  977.471032] iwlwifi 0000:20:00.0: REPLY_CT_KILL_CONFIG_CMD failed
[  977.971017] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  977.971023] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 14
[  977.977697] iwlwifi 0000:20:00.0: Current HW read_ptr 14 write_ptr 14
[  978.478020] iwlwifi 0000:20:00.0: Queue 4 stuck for 2000 ms.
[  978.478024] iwlwifi 0000:20:00.0: Current SW read_ptr 11 write_ptr 14
[  978.484706] iwlwifi 0000:20:00.0: Current HW read_ptr 14 write_ptr 14
[  978.484710] iwlwifi 0000:20:00.0: On demand firmware reload
[  978.485017] ------------[ cut here ]------------
[  978.485038] WARNING: at drivers/net/wireless/iwlwifi/iwl-mac80211.c:325 iwlagn_mac_start+0x10e/0x110 [iwlwifi]()
[  978.485041] Hardware name: HP xw8600 Workstation
[  978.485044] Modules linked in: aes_generic arc4 iwlwifi mac80211 cfg80211 fuse autofs4 cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput sg hp_wmi sparse_keymap serio_raw microcode shpchp i5400_edac edac_core ext4 mbcache jbd2 firewire_ohci firewire_core crc_itu_t sd_mod crc_t10dif sr_mod cdrom mptsas mptscsih mptbase scsi_transport_sas ahci libahci pata_acpi ata_generic ata_piix nouveau ttm drm_kms_helper drm hwmon i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[  978.485137] Pid: 4212, comm: kworker/2:2 Not tainted 3.3.0-rc6-wl+ #7
[  978.485140] Call Trace:
[  978.485151]  [<ffffffff8105104f>] warn_slowpath_common+0x7f/0xc0
[  978.485156]  [<ffffffff810510aa>] warn_slowpath_null+0x1a/0x20
[  978.485166]  [<ffffffffa0510bfe>] iwlagn_mac_start+0x10e/0x110 [iwlwifi]
[  978.485196]  [<ffffffffa0496377>] ieee80211_reconfig+0x1b7/0xcd0 [mac80211]
[  978.485203]  [<ffffffff814e366e>] ? mutex_unlock+0xe/0x10
[  978.485217]  [<ffffffffa0471b79>] ieee80211_restart_work+0x89/0xb0 [mac80211]
[  978.485222]  [<ffffffff8106ecae>] process_one_work+0x1ae/0x500
[  978.485226]  [<ffffffff8106ec3f>] ? process_one_work+0x13f/0x500
[  978.485239]  [<ffffffffa0471af0>] ? ieee80211_recalc_smps_work+0x50/0x50 [mac80211]
[  978.485244]  [<ffffffff810713db>] worker_thread+0x17b/0x3b0
[  978.485249]  [<ffffffff81071260>] ? manage_workers+0x120/0x120
[  978.485253]  [<ffffffff810768c6>] kthread+0xc6/0xd0
[  978.485259]  [<ffffffff81084d9b>] ? finish_task_switch+0x4b/0xf0
[  978.485264]  [<ffffffff814f01b4>] kernel_thread_helper+0x4/0x10
[  978.485269]  [<ffffffff814e6874>] ? retint_restore_args+0x13/0x13
[  978.485273]  [<ffffffff81076800>] ? __init_kthread_worker+0x70/0x70
[  978.485277]  [<ffffffff814f01b0>] ? gs_change+0x13/0x13
[
