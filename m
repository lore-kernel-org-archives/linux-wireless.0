Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360Ab1LPTjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:39:00 -0500
Date: Fri, 16 Dec 2011 18:51:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtlwifi: Partial revert of 6539306b
Message-ID: <20111216175142.GA4756@redhat.com> (sfid-20111216_203903_699789_F0B9EFF3)
References: <4eeb7bac./0AE71DUR6ucOIhZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4eeb7bac./0AE71DUR6ucOIhZ%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry.

On Fri, Dec 16, 2011 at 11:11:08AM -0600, Larry Finger wrote:
> When I tested commit 6539306, I did not notice that loading an out-of-tree
> module turns off lockdep testing in kernel 3.2. For that reason, I missed
> the kernel WARNING shown below:
> 
> As I stated earlier, my understanding of locking may not up to the task
> of fixing this problem. I first tried using one mutex to replace ips_lock
> and a second to replace lps_lock. That still got a warning.
> 
> The solution below, which partially reverts 6539306 and restores one of the
> spinlocks, does not generate any lockdep warnings. This solution also has
> the advantage that it this locking is only used when the NIC is turned on.
> I am, however, ready to test any solution that eliminates both spinlocks.
[snip]

> [   84.168146] ------------[ cut here ]------------
> [   84.168155] WARNING: at kernel/mutex.c:198 mutex_lock_nested+0x309/0x310()
> [   84.168158] Hardware name: HP Pavilion dv2700 Notebook PC
> [   84.168161] Modules linked in: nfs lockd auth_rpcgss nfs_acl sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf e
> xt3 jbd ide_cd_mod cdrom snd_hda_codec_conexant arc4 rtl8192ce ide_pci_generic rtl8192c_common rtlwifi snd_hda_intel mac80211 snd_hda_codec snd_pcm snd_timer
>  amd74xx ide_core cfg80211 k8temp snd joydev soundcore hwmon battery forcedeth i2c_nforce2 sg rfkill ac serio_raw snd_page_alloc button video i2c_core ipv6 a
> utofs4 ext4 mbcache jbd2 crc16 sd_mod ahci ohci_hcd libahci libata scsi_mod ehci_hcd usbcore usb_common fan processor thermal
> [   84.168231] Pid: 1218, comm: kworker/u:2 Not tainted 3.2.0-rc5-wl+ #155
> [   84.168234] Call Trace:
> [   84.168240]  [<ffffffff81048aaa>] warn_slowpath_common+0x7a/0xb0
> [   84.168245]  [<ffffffff81048af5>] warn_slowpath_null+0x15/0x20
> [   84.168249]  [<ffffffff813811f9>] mutex_lock_nested+0x309/0x310
> [   84.168269]  [<ffffffffa00793f9>] ? rtl_ips_nic_on+0x49/0xb0 [rtlwifi]
> [   84.168277]  [<ffffffffa00793f9>] rtl_ips_nic_on+0x49/0xb0 [rtlwifi]
> [   84.168284]  [<ffffffffa007ab85>] rtl_pci_tx+0x1b5/0x560 [rtlwifi]
> [   84.168291]  [<ffffffffa007635a>] rtl_op_tx+0x9a/0xa0 [rtlwifi]
> [   84.168359]  [<ffffffffa043cf51>] __ieee80211_tx+0x181/0x2b0 [mac80211]

Hugh, good catch, how I missed that? Fix is ok, except
spin_lock_irqsave(, flags) should be used, as we call this function
both from work and from interrupt context.

What brings us to the problems we had before. I think right solution
would be using one spinlock, as we protect the same data, and
change code such there were no delays when holding the spinlocks
(maybe this is done already, not sure).

Anyway for now having two locks is fine, I think, it does not make
things worse than they was before.

Thanks
Stanislaw
 
