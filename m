Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41483 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab0AOORL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 09:17:11 -0500
Received: by yxe17 with SMTP id 17so599642yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 06:17:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bfff2faa1001120958m6f6a771pdbd5e8c628f6b06f@mail.gmail.com>
References: <bfff2faa0912190727jc7fa067gf46425d1cd443698@mail.gmail.com>
	 <bfff2faa0912230911w15966e9sbfbba9bd303d3314@mail.gmail.com>
	 <1261589400.7538.4.camel@mj>
	 <43e72e890912230933h3eac574ya7b6b359a32524cb@mail.gmail.com>
	 <bfff2faa1001120958m6f6a771pdbd5e8c628f6b06f@mail.gmail.com>
Date: Fri, 15 Jan 2010 09:17:09 -0500
Message-ID: <bfff2faa1001150617j7b876749ic8730d4efa4c0570@mail.gmail.com>
Subject: Re: modprobe fail and subsequent crash on rmmod ath9k D-Link DWA 652
From: Russ Adams <russ.adams@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've recompiled a vanilla kernel, 2.6.32.3 with debug for ATH9K module
enabled.  I found two main things:

1. When I booted, ath9k was being inserted without the debug parameter
via my initrd.

  * Subsequent calls to rmmod ath9k would trigger the Killed message.
  * Manually inserting the ath9k driver with debug symbol (modprobe
debug=0xffffffff) would fail with no error in dmesg.

2. If I explicitly disabled ath9k by adding disablemodules=ath9k to my
kernel arguments in /boot/grub/menu.lst ath9k is *not* inserted
automatically at boot. (or for that matter if I simply physically
removed the card at boot).  Now with debug symbols on or off, the
driver correctly installs itself and functions properly thereafter.
rmmod ath9k does not cause the Killed message.

Now I'm suspicious that my initrd was loading ath9k before some
dependency was filled.  Any thoughts in that direction?

Below is the dmesg output when rmmod ath9k fails:

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c117338a>] kref_put+0x1a/0x60
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/size
Modules linked in: thermal processor fan button battery ac mmc_block
sdhci_pci sdhci snd_intel8x0m snd_intel8x0 snd_ac97_codec snd_pcm_oss
snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ac97_bus
psmouse evdev rtc_cmos rtc_core rtc_lib ext3 jbd mbcache hid_microsoft
ath9k(-) usbhid hid mac80211 ath cfg80211 rfkill led_class b44 ssb
mmc_core pcmcia ipw2100 libipw uhci_hcd yenta_socket rsrc_nonstatic
lib80211 pcmcia_core mii sr_mod sd_mod cdrom ehci_hcd usbcore ata_piix
ata_generic pata_acpi libata scsi_mod

Pid: 1790, comm: rmmod Not tainted (2.6.32.3-ARCH #1) Inspiron 9200
EIP: 0060:[<c117338a>] EFLAGS: 00010202 CPU: 0
EIP is at kref_put+0x1a/0x60
EAX: 0000000c EBX: 0000000c ECX: f695c360 EDX: f84504c0
ESI: f84504c0 EDI: f732188c EBP: f695c260 ESP: f622feb8
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process rmmod (pid: 1790, ti=f622e000 task=f61025b0 task.ti=f622e000)
Stack:
f695c260 f858c910 f844414d f695ca54 f695ca54 f695ca54 f85640ed f695ca54
<0> 00000200 f858b960 f695ca54 f858c910 f732188c f858c944 f85641c8 f7321800
<0> c11887b6 f7321858 c11fb94d f7321858 f858c910 c11fba37 f858c8e0 f858c910
Call Trace:
[<f844414d>] ? ieee80211_unregister_hw+0x5d/0xd0 [mac80211]
[<f85640ed>] ? ath_detach+0x7d/0x150 [ath9k]
[<f85641c8>] ? ath_cleanup+0x8/0x30 [ath9k]
[<c11887b6>] ? pci_device_remove+0x16/0x40
[<c11fb94d>] ? __device_release_driver+0x4d/0xb0
[<c11fba37>] ? driver_detach+0x87/0x90
[<c11fac1b>] ? bus_remove_driver+0x5b/0xa0
[<c11889fb>] ? pci_unregister_driver+0x2b/0x80
[<f856e298>] ? ath9k_exit+0x8/0x36 [ath9k]
[<c1072c30>] ? sys_delete_module+0x190/0x240
[<c10cb9e7>] ? remove_vma+0x37/0x50
[<c1025bd1>] ? do_page_fault+0x111/0x330
[<c10039f3>] ? sysenter_do_call+0x12/0x28
Code: 00 c7 00 01 00 00 00 0f ae f0 89 f6 c3 8d 74 26 00 83 ec 08 85
d2 89 1c 24 89 c3 89 74 24 04 89 d6 74 39 81 fa 50 d5 0d c1 74 20 <3e>
ff 0b 0f 94 c2 31 c0 84 d2 74 09 89 d8 ff d6 b8 01 00 00 00
EIP: [<c117338a>] kref_put+0x1a/0x60 SS:ESP 0068:f622feb8
CR2: 000000000000000c
---[ end trace 4ce8923552844d86 ]---


On Tue, Jan 12, 2010 at 12:58 PM, Russ Adams <russ.adams@gmail.com> wrote:
> Apologies on the delay here.  I will make a priority to compile a
> vanilla kernel this week and do suggested debugging steps against it.
>
> On Wed, Dec 23, 2009 at 12:33 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, Dec 23, 2009 at 9:30 AM, Pavel Roskin <proski@gnu.org> wrote:
>>> On Wed, 2009-12-23 at 12:11 -0500, Russ Adams wrote:
>>>> Nothing new on this just yet.
>>>>
>>>> Tonight I will try 2.6.32-2 to see if that fixes the problem.  Does
>>>> anyone have any debugging steps I can try?
>>>
>>> Remember, I asked you to show the debug messages after the ath9k module
>>> is loaded.  If it's loaded on startup, you can blacklist it and then
>>> load manually with modprobe.
>>>
>>> It seems to me that something fails during the initialization, which
>>> causes a crash at the unload time.  But since ath9k is working properly
>>> for most of us, it's hard to figure out what is failing and how to model
>>> the problem on functioning hardware.
>>
>> Also, please see:
>>
>> http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
>>
>> specifically the parts about the latest stable kernels.
>>
>>  Luis
>>
>
