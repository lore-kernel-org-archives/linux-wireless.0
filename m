Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab1FBQXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:23:31 -0400
Date: Thu, 2 Jun 2011 18:22:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 07/10] iwlagn: advertise interface combinations
Message-ID: <20110602162241.GE4580@redhat.com> (sfid-20110602_182334_892232_4236B0F8)
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
 <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 27, 2011 at 08:40:30AM -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> With this, iwlwifi will advertise the limits on
> concurrency of virtual interfaces.

John, please revert this patch, it disallow to register new device
with below error. I believe, Wey already asked you to not a apply it.

WARNING: at net/wireless/core.c:468 wiphy_register+0x46e/0x5c0
[cfg80211]()
Hardware name: HP xw8600 Workstation
Modules linked in: iwlagn(+) mac80211 cfg80211 fuse cpufreq_ondemand
acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4
nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput sg hp_wmi
sparse_keymap rfkill microcode serio_raw shpchp ext4 mbcache jbd2 sr_mod
cdrom sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t mptsas
mptscsih mptbase scsi_transport_sas ahci libahci pata_acpi ata_generic
ata_piix floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core
mxm_wmi wmi video [last unloaded: scsi_wait_scan]
Pid: 7333, comm: firmware/iwlwif Not tainted 3.0.0-rc1-wl+ #82
Call Trace:
 [<ffffffff8106438f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810643ea>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa03ea65e>] wiphy_register+0x46e/0x5c0 [cfg80211]
 [<ffffffff8115ce73>] ? __kmalloc+0x1b3/0x2d0
 [<ffffffffa042732e>] ? ieee80211_register_hw+0xde/0x670 [mac80211]
 [<ffffffffa04274dc>] ieee80211_register_hw+0x28c/0x670 [mac80211]
 [<ffffffffa047b9ca>] iwl_ucode_callback+0xd3a/0x11d0 [iwlagn]
 [<ffffffff81220607>] ? kobject_release+0xa7/0x1d0
 [<ffffffff8130f160>] ? _request_firmware+0x4e0/0x4e0
 [<ffffffff8130f1a1>] request_firmware_work_func+0x41/0x80
 [<ffffffff81088376>] kthread+0xb6/0xc0
 [<ffffffff810a1575>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff814ba404>] kernel_thread_helper+0x4/0x10
 [<ffffffff814b1454>] ? retint_restore_args+0x13/0x13
 [<ffffffff810882c0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff814ba400>] ? gs_change+0x13/0x13
---[ end trace 971e83aec02c096b ]---
iwlagn 0000:80:00.0: Failed to register hw (error -22)

Stanislaw
