Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1BNOY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:24:28 -0500
Date: Mon, 14 Feb 2011 15:24:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix dma mappings and skbs leak
Message-ID: <20110214142432.GC14827@redhat.com>
References: <1297683529-4053-1-git-send-email-sgruszka@redhat.com>
 <20110214125046.GB14827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110214125046.GB14827@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 01:50:47PM +0100, Stanislaw Gruszka wrote:
> On Mon, Feb 14, 2011 at 12:38:49PM +0100, Stanislaw Gruszka wrote:
> > WARNING: at lib/dma-debug.c:689 dma_debug_device_change+0x15a/0x1b0()
> > Hardware name: HP xw8600 Workstation
> > pci 0000:80:00.0: DMA-API: device driver has pending DMA allocations while released from device [count=444]
> > Modules linked in: iwlagn(-) iwlcore cryptd aes_x86_64 aes_generic fuse autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput hp_wmi sparse_keymap wmi sg microcode serio_raw iTCO_wdt iTCO_vendor_support tg3 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm arc4 ecb snd_timer snd soundcore snd_page_alloc i5k_amb hwmon i5400_edac edac_core shpchp mac80211 cfg80211 rfkill ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas pata_acpi ata_generic ata_piix ahci libahci floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iwlcore]
> > Pid: 7382, comm: rmmod Not tainted 2.6.38-rc3-wl+ #17
> > Call Trace:
> >  [<ffffffff81064bef>] ? warn_slowpath_common+0x7f/0xc0
> >  [<ffffffff81064ce6>] ? warn_slowpath_fmt+0x46/0x50
> >  [<ffffffff8125ea6b>] ? dma_debug_device_change+0xdb/0x1b0
> >  [<ffffffff8125eaea>] ? dma_debug_device_change+0x15a/0x1b0
> >  [<ffffffff814dfed8>] ? notifier_call_chain+0x58/0xb0
> >  [<ffffffff8108e6a0>] ? __blocking_notifier_call_chain+0x60/0x90
> >  [<ffffffff8108e6e6>] ? blocking_notifier_call_chain+0x16/0x20
> >  [<ffffffff81326fcc>] ? __device_release_driver+0xbc/0xe0
> >  [<ffffffff813270c8>] ? driver_detach+0xd8/0xe0
> >  [<ffffffff81325e91>] ? bus_remove_driver+0x91/0x100
> >  [<ffffffff813278e2>] ? driver_unregister+0x62/0xa0
> >  [<ffffffff81269f94>] ? pci_unregister_driver+0x44/0xa0
> >  [<ffffffffa0750e75>] ? iwl_exit+0x15/0x1c [iwlagn]
> >  [<ffffffff810abd22>] ? sys_delete_module+0x1a2/0x270
> >  [<ffffffff814db0d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >  [<ffffffff8100bf82>] ? system_call_fastpath+0x16/0x1b
> 
> Hmm, I still have this warning after patch applied, so problem is not
> fully fixed.
> 
> Plese hold with with that patch for now.

Patch for sure fixes iptables modules unload issue for me. There
must be some other DMA mapping leaks somewhere, I'm not sure
where, iwlwifi need to be carefully reviewed in this regard.

I'm going to repost with different changelog.

Stanislaw
