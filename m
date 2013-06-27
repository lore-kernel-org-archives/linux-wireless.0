Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:49964 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3F0KIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 06:08:38 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so205474bkc.30
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 03:08:37 -0700 (PDT)
Message-ID: <51CC0F22.7030004@gmail.com> (sfid-20130627_120841_726100_5E6E00D4)
Date: Thu, 27 Jun 2013 12:08:34 +0200
From: "shiki.biomernok" <shiki.biomernok@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net>
In-Reply-To: <51CB4E31.50502@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The closed source driver is not working either.
It compiled like a charm, and it loads perfectly.
(I even blacklisted the open-source one!)

But there is nothing in iwconfig or ifconfig.
Here is the dmesg: http://pastebin.com/EX8h1HfZ

I really don't want to waste your time guys by the way. If there is no 
way to fix it, let's just leave it. (Don't get me wrong I know things 
can be troublesome on Linux and I'm still willing to try anything. I 
just bet you have better things to do. :))

On 2013-06-26 22:25, Larry Finger wrote:
> On 06/26/2013 12:29 PM, shiki.biomernok wrote:
>> Hello Larry/Mailing list!
>>
>> I have compiled and installed the new wireless-testing kernel from git.
>> I'm sure I used the new kernel, as the device lighted up as soon as I 
>> plugged
>> in. (And I got some new atheros ac module at "make oldconfig".)
>> There was no need for manual echo or modprobe.
>>
>> Yet, the device is not working. It dies at the very same step.
>> Here is the dmesg: http://pastebin.com/C1MNdFiw
>>
>> Please, let me know if I can help with anything.
>> Any debug option, patch or things like that.
>>
>> My offer is still there Larry, I'm willing to give you a full SSH 
>> access to the
>> machine with this stuff plugged in.
>> Besides that, I have no other idea.
>>
>>
>> ! My router runs OpenWRT (latest stable), so I could also gather info 
>> from
>> there. If it's possible.
>> (I checked dmesg but there is nothing. Only some non-crucial info 
>> about the
>> generic eth ports and such.)
>>
>> Thank you for the help.
>>
>> (By the way if the chip is rare (no other people will benefit), then 
>> I can just
>> get it back and ask for a refund. But if others use it as well, then 
>> it's not a
>> waste of time... I guess.)
>
> I think the TP-Link 8200ND is relatively new. You have version 0x11 
> for your chip, and mine is 0x10. That could be a difference.
>
> Whay are you forcing the module loading? As indicated by the (F) in 
> the traceback, it looks as if all of them are being forced.
>
> [   13.111932] BUG: unable to handle kernel NULL pointer dereference 
> at 0000000000000005
> [   13.111943] IP: [<ffffffffa03196c7>] iwl_dbgfs_register+0x27/0x70 
> [iwldvm]
> [   13.111944] PGD 0
> [   13.111945] Oops: 0000 [#1] PREEMPT SMP
> [   13.111964] Modules linked in: arc4(F) snd_hda_codec(F) 
> snd_hwdep(F) snd_pcm(F) iwldvm(F+) snd_page_alloc(F) thinkpad_acpi(F) 
> nvram(F) mac80211(F) snd_seq_midi(F) i915(F+) snd_seq_midi_event(F) 
> drm_kms_helper(F) snd_rawmidi(F) drm(F) snd_seq(F) snd_timer(F) 
> coretemp(F) snd_seq_device(F) r592(F) i2c_algo_bit(F) snd(F) 
> iwlwifi(F) soundcore(F) tpm_tis(F) memstick(F) btusb(F) microcode(F) 
> psmouse(F) bluetooth(F) serio_raw(F) wmi(F) cfg80211(F) video(F) 
> lpc_ich(F) hid_generic(F) usbhid(F) hid(F) sdhci_pci(F) sdhci(F) 
> ahci(F) libahci(F) e1000e(F) ptp(F) pps_core(F)
> [   13.111967] CPU: 1 PID: 741 Comm: modprobe Tainted: GF 
> 3.10.0-rc7-wl-x1-1000hz-wifitesting #1
> [   13.111968] Hardware name: LENOVO 208252G/208252G, BIOS 6FET92WW 
> (3.22 ) 12/14/2011
> [   13.111969] task: ffff8801a3f5d640 ti: ffff8801a1b9e000 task.ti: 
> ffff8801a1b9e000
> [   13.111975] RIP: 0010:[<ffffffffa03196c7>] [<ffffffffa03196c7>] 
> iwl_dbgfs_register+0x27/0x70 [iwldvm]
>
> To help us debug this matter, the attached patch will let you compile 
> the vendor driver that you downloaded from the vendor site.
>
> Larry
>
>

