Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab0FNU0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:32 -0400
Subject: Re: [PATCH] iwlwifi: cancel scan watchdog in iwl_bg_abort_scan
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mihai Harpau <mishu@piatafinanciara.ro>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1276540554-5336-1-git-send-email-linville@tuxdriver.com>
References: <1276540554-5336-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 13:26:31 -0700
Message-ID: <1276547191.25793.1433.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 11:35 -0700, John W. Linville wrote:
> Avoids this:
> 
> WARNING: at net/mac80211/scan.c:312 ieee80211_scan_completed+0x5f/0x1f1
> [mac80211]()
> Hardware name: Latitude E5400
> Modules linked in: aes_x86_64 aes_generic fuse ipt_MASQUERADE iptable_nat
> nf_nat rfcomm sco bridge stp llc bnep l2cap sunrpc cpufreq_ondemand
> acpi_cpufreq freq_table xt_physdev ip6t_REJECT nf_conntrack_ipv6
> ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb
> snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec
> snd_hwdep snd_seq snd_seq_device iwlcore snd_pcm dell_wmi sdhci_pci sdhci
> iTCO_wdt tg3 dell_laptop mmc_core i2c_i801 wmi mac80211 snd_timer
> iTCO_vendor_support btusb joydev dcdbas cfg80211 bluetooth snd soundcore
> microcode rfkill snd_page_alloc firewire_ohci firewire_core crc_itu_t
> yenta_socket rsrc_nonstatic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> output [last unloaded: scsi_wait_scan]
> Pid: 979, comm: iwlagn Tainted: G        W  2.6.33.3-85.fc13.x86_64 #1
> Call Trace:
> [<ffffffff8104b558>] warn_slowpath_common+0x77/0x8f
> [<ffffffff8104b57f>] warn_slowpath_null+0xf/0x11
> [<ffffffffa01bb7d9>] ieee80211_scan_completed+0x5f/0x1f1 [mac80211]
> [<ffffffffa02a23f0>] iwl_bg_scan_completed+0xbb/0x17a [iwlcore]
> [<ffffffff81060d3d>] worker_thread+0x1a4/0x232
> [<ffffffffa02a2335>] ? iwl_bg_scan_completed+0x0/0x17a [iwlcore]
> [<ffffffff81064817>] ? autoremove_wake_function+0x0/0x34
> [<ffffffff81060b99>] ? worker_thread+0x0/0x232
> [<ffffffff810643c7>] kthread+0x7a/0x82
> [<ffffffff8100a924>] kernel_thread_helper+0x4/0x10
> [<ffffffff8106434d>] ? kthread+0x0/0x82
> [<ffffffff8100a920>] ? kernel_thread_helper+0x0/0x10
> 
> Reported here:
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=590436
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Reported-by: Mihai Harpau <mishu@piatafinanciara.ro>
> Cc: stable@kernel.org
> ---

Great catch. Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


