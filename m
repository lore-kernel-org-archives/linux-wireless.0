Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1BOLej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 06:34:39 -0500
Date: Tue, 15 Feb 2011 12:34:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
Message-ID: <20110215113444.GC2162@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
 <1297698696.4723.16.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297698696.4723.16.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 07:51:36AM -0800, wwguy wrote:
> On Mon, 2011-02-14 at 06:32 -0800, Stanislaw Gruszka wrote:
> > Since commit commit 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7
> > "iwlwifi: avoid Tx queue memory allocation in interface down" we do
> > not unmap dma and free skbs when down device and there is pending
> > transfer. What in consequence may cause that system hung when
> > performing shutdown at iptables module unload.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > v1 -> v2: do not claim patch fixes warning, which is still
> > observable with patch applied
> > 
> >  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++-
> >  drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +
> >  drivers/net/wireless/iwlwifi/iwl-tx.c     |   61 ++++++++++++++++++++--------
> >  3 files changed, 56 insertions(+), 19 deletions(-)
> 
> Are you still seeing the "warning"

Today I tried to reproduce problem a few times with
patch applied and does not see dma warning. Also
iptables modules still unload fine.

However during testing, I triggered different warning:

WARNING: at lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
Hardware name: HP xw8600 Workstation
ODEBUG: free active (active state 0) object type: timer_list
Modules linked in: aes_x86_64 aes_generic fuse cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput hp_wmi sparse_keymap floppy wmi sg microcode serio_raw arc4 tg3 ecb shpchp iwlagn(-) iwlcore mac80211 cfg80211 rfkill ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas pata_acpi ata_generic ata_piix ahci libahci nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 9139, comm: rmmod Not tainted 2.6.38-rc4-wl+ #21
Call Trace:
 [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
 [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff81226eec>] ? debug_print_object+0x5c/0x70
 [<ffffffff81227585>] ? debug_check_no_obj_freed+0x125/0x210
 [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
 [<ffffffff81156092>] ? kfree+0xc2/0x2f0
 [<ffffffff813ec3c5>] ? netdev_release+0x45/0x60
 [<ffffffff812f0e67>] ? device_release+0x27/0xa0
 [<ffffffff81216ddd>] ? kobject_release+0x8d/0x1a0
 [<ffffffff81216d50>] ? kobject_release+0x0/0x1a0
 [<ffffffff812183b7>] ? kref_put+0x37/0x70
 [<ffffffff81216c57>] ? kobject_put+0x27/0x60
 [<ffffffff813d5b1b>] ? netdev_run_todo+0x1ab/0x270
 [<ffffffff813e751e>] ? rtnl_unlock+0xe/0x10
 [<ffffffffa02a5188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa036ced7>] ? iwl_pci_remove+0xdb/0x22a [iwlagn]
 [<ffffffff8123cbe2>] ? pci_device_remove+0x52/0x120
 [<ffffffff812f5005>] ? __device_release_driver+0x75/0xe0
 [<ffffffff812f5148>] ? driver_detach+0xd8/0xe0
 [<ffffffff812f3f11>] ? bus_remove_driver+0x91/0x100
 [<ffffffff812f5962>] ? driver_unregister+0x62/0xa0
 [<ffffffff8123cf94>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa036cdf5>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810ab492>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff81498689>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b

It looks more like mac80211 issue for me.

Stanislaw
