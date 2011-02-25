Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13687 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab1BYRCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 12:02:43 -0500
Subject: Re: [PATCH v2 1/3] iwlwifi: fix dma mappings and skbs leak
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
References: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:47:44 -0800
Message-ID: <1298652464.28351.22.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-02-25 at 07:57 -0800, Stanislaw Gruszka wrote:
> Since commit commit 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7
> "iwlwifi: avoid Tx queue memory allocation in interface down" we do
> not unmap dma and free skbs when down device and there is pending
> transfer. What in consequence may cause that system hung (waiting
> for free skb's) when performing shutdown at iptables module unload.
> 
> DMA leak manifest itself following warning:
> 
> WARNING: at lib/dma-debug.c:689 dma_debug_device_change+0x15a/0x1b0()
> Hardware name: HP xw8600 Workstation
> pci 0000:80:00.0: DMA-API: device driver has pending DMA allocations while released from device [count=240]
> Modules linked in: iwlagn(-) aes_x86_64 aes_generic fuse cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput hp_wmi sparse_keymap sg wmi microcode serio_raw tg3 arc4 ecb shpchp mac80211 cfg80211 rfkill ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas pata_acpi ata_generic ata_piix ahci libahci floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iwlagn]
> Pid: 9131, comm: rmmod Tainted: G        W   2.6.38-rc6-wl+ #33
> Call Trace:
>  [<ffffffff810649ef>] ? warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81064ae6>] ? warn_slowpath_fmt+0x46/0x50
>  [<ffffffff812320ab>] ? dma_debug_device_change+0xdb/0x1b0
>  [<ffffffff8123212a>] ? dma_debug_device_change+0x15a/0x1b0
>  [<ffffffff8149dc18>] ? notifier_call_chain+0x58/0xb0
>  [<ffffffff8108e370>] ? __blocking_notifier_call_chain+0x60/0x90
>  [<ffffffff8108e3b6>] ? blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff812f570c>] ? __device_release_driver+0xbc/0xe0
>  [<ffffffff812f5808>] ? driver_detach+0xd8/0xe0
>  [<ffffffff812f45d1>] ? bus_remove_driver+0x91/0x100
>  [<ffffffff812f6022>] ? driver_unregister+0x62/0xa0
>  [<ffffffff8123d5d4>] ? pci_unregister_driver+0x44/0xa0
>  [<ffffffffa05632d1>] ? iwl_exit+0x15/0x1c [iwlagn]
>  [<ffffffff810ab492>] ? sys_delete_module+0x1a2/0x270
>  [<ffffffff81498da9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b
> 
> I still can observe above warning after apply patch, but it is very
> hard to reproduce it, and have count=1. Whereas that one is easy to
> reproduce using debugfs force_reset while transmitting data, and have
> very big counts eg. 240, like quoted here. So count=1 WARNING seems
> to be different issue that need to be resolved separately.
> 
> v1 -> v2: fix infinity loop bug I made during "for" to "while" loop transition.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 ++++-
>  drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +
>  drivers/net/wireless/iwlwifi/iwl-tx.c     |   73 +++++++++++++++++++----------
>  3 files changed, 61 insertions(+), 26 deletions(-)
> 

Good catch, thank you very much 

I don't think we need EXPORT_SYMBOL anymore after driver split


Wey

