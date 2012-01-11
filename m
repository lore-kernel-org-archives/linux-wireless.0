Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34580 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab2AKPlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 10:41:15 -0500
Received: by obbup16 with SMTP id up16so995122obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 07:41:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0D9BF8.7020001@broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
	<4F0D7F6B.5000601@broadcom.com>
	<CAC9WiBgp02u90rJNC64kKU8GN7jcP_YOSRXSBbR83kHvf3CneQ@mail.gmail.com>
	<4F0D9BF8.7020001@broadcom.com>
Date: Wed, 11 Jan 2012 16:41:14 +0100
Message-ID: <CAC9WiBhvTfRS9P1eMj-Ev3O9gSJf7O9tAO5BSGT7XX2tnDdhtA@mail.gmail.com> (sfid-20120111_164119_396243_FE160914)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 11, 2012 at 3:26 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/11/2012 02:13 PM, Francis Moreau wrote:
>> On Wed, Jan 11, 2012 at 1:24 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 01/11/2012 12:40 PM, Francis Moreau wrote:
>>>> Hi,
>>>>
>>>> This has finally been merged and is part of the 3.2 release.
>>>>
>>>> So now distros don't ship the brcmsmac driver anymore which is
>>>> basically the only driver which can handle my card.
>>>
>>> I am not sure why you come to that conclusion,
>>
>> I checked on both OpenSuse and Mandriva, and they both have CONFIG_BCMA=m.
>>
>>> For kernel v3.3 the brcmsmac driver will be using bcma.
>>
>> Great.
>>
>> But v3.2...
>>
>
> Given the configuration BCMA=m I agree that brcmsmac is probably not in
> the distro in binary form. However, you can probably install the kernel
> source package and rebuilt the kernel with BCMA=n and BRCMSMAC=m.
>
> Gr. AvS
>

and now using the brcmsmac gives the following WARN:

[   98.406709] ------------[ cut here ]------------
[   98.406743] WARNING: at net/mac80211/rx.c:2979
ieee80211_rx+0x91b/0x9e0 [mac80211]()
[   98.406747] Hardware name: Vostro 3500
[   98.406749] Modules linked in: rfcomm bridge stp bnep btusb
bluetooth nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc fuse
af_packet ipv6 arc4 brcmsmac mac80211 brcmutil snd_hda_codec_hdmi
snd_hda_codec_idt cfg80211 uvcvideo snd_hda_intel dell_laptop
snd_hda_codec rfkill videodev snd_hwdep sg snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm
snd_timer snd_mixer_oss snd mei(C) r8169 mii media v4l2_compat_ioctl32
soundcore snd_page_alloc sr_mod iTCO_wdt iTCO_vendor_support intel_ips
crc8 cordic dcdbas i2c_i801 i915 drm_kms_helper drm i2c_algo_bit
i2c_core coretemp binfmt_misc cpufreq_ondemand cpufreq_conservative
cpufreq_powersave acpi_cpufreq freq_table mperf nvram dm_mod joydev
dell_wmi sparse_keymap evdev kvm_intel wmi kvm video battery ata_piix
ahci libahci libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore usb_common
[   98.406857] Pid: 0, comm: swapper/0 Tainted: G        WC   3.2+ #1
[   98.406861] Call Trace:
[   98.406864]  <IRQ>  [<ffffffff8106809f>] warn_slowpath_common+0x7f/0xc0
[   98.406880]  [<ffffffff810680fa>] warn_slowpath_null+0x1a/0x20
[   98.406896]  [<ffffffffa050d2bb>] ieee80211_rx+0x91b/0x9e0 [mac80211]
[   98.406902]  [<ffffffff8105776d>] ? update_curr+0x1cd/0x220
[   98.406913]  [<ffffffffa04f0dd9>]
ieee80211_tasklet_handler+0xb9/0x160 [mac80211]
[   98.406919]  [<ffffffff8106f43d>] tasklet_action+0xcd/0x110
[   98.406924]  [<ffffffff8106efda>] __do_softirq+0xaa/0x1e0
[   98.406931]  [<ffffffff8146792c>] call_softirq+0x1c/0x30
[   98.406938]  [<ffffffff81015255>] do_softirq+0x65/0xa0
[   98.406942]  [<ffffffff8106edde>] irq_exit+0x8e/0xc0
[   98.406948]  [<ffffffff814681e6>] do_IRQ+0x66/0xe0
[   98.406954]  [<ffffffff8145da2e>] common_interrupt+0x6e/0x6e
[   98.406957]  <EOI>  [<ffffffff8129e2e0>] ? intel_idle+0xe0/0x150
[   98.406968]  [<ffffffff8129e2c6>] ? intel_idle+0xc6/0x150
[   98.406975]  [<ffffffff8136e678>] cpuidle_idle_call+0xd8/0x1b0
[   98.406980]  [<ffffffff8101302b>] cpu_idle+0xcb/0x120
[   98.406987]  [<ffffffff814410c2>] rest_init+0x72/0x80
[   98.406994]  [<ffffffff81ac7cd9>] start_kernel+0x3c5/0x3d0
[   98.406999]  [<ffffffff81ac7346>] x86_64_start_reservations+0x131/0x135
[   98.407004]  [<ffffffff81ac744d>] x86_64_start_kernel+0x103/0x112
[   98.407009] ---[ end trace 4b7390abe635c92a ]---

Could anybody tell me what's wrong ?

Thanks
-- 
Francis
