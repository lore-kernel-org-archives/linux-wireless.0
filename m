Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41845 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1HVL1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 07:27:42 -0400
Received: by wwe5 with SMTP id 5so2066346wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 04:27:41 -0700 (PDT)
Date: Mon, 22 Aug 2011 13:27:37 +0200
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
Message-ID: <20110822112737.GA5936@stt008.linux.site> (sfid-20110822_132746_758987_FB3C9243)
References: <20110814121646.GA5188@stt008.linux.site> <4E4A5641.4020604@broadcom.com> <1313509211.2065.36.camel@dcbw.foobar.com> <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com> <4E4E73F4.4040105@broadcom.com> <20110819152140.GA7506@stt008.linux.site> <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com> <4E52297D.9090301@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <4E52297D.9090301@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

El 2011-08-22 a las 12:03 +0200, Roland Vossen escribió:

> Hello Camaleón,
>
>> Okay, I finally managed to compile a kernel with the required flag
>> enabled and booted with it. I am attaching the resulting trace file,
>> should you need additional information, kindly ask.
>
> thanks! I did the same thing on my setup and diff'ed the resulting trace  
> file with yours. I spotted a difference but it should not be relevant:
>
> (your trace): drv_prepare_multicast: phy0 prepare mc (5)
> (my trace): drv_prepare_multicast: phy0 prepare mc (1)
>
> I am wondering if the problem could be explained by a RF kill switch  
> being active. Can you send me the output of 'rfkill list' and 'lsmod' ?

root@stt300:~# rfkill list
0: hp-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
	
"lsmod" is attached.	

> Are there wireless-related LEDs on your machine and do they act  
> differently between kernel 3.0.1 and 2.6.39-2 ?

There is one led, the one to enable/disable wifi and bluetooh but it 
behaves the same in both kernels.

One difference, though, is that now (with kernel 3.0.0) when I shutdown 
the system it hangs at NetworkManager if wifi LED is on. As soon as I 
turn off the wifi led, the system can continue the shutdown.

Moreover, "service network-manager stop" returns "failed" unless I 
first turn off the wifi led (and so phy0 hard blocked is set as "yes").

> Can you do a 'rfkill unblock all' to see if that makes a difference ?

It makes no difference. No wifi networks are detected automatically nor 
connecting manually to a hidden network is possible (unless I sit next 
to the AP).

Just in case this helps, I have tried another wifi adapater (USB, based 
on rt2xx chipset) and works like a charm, I mean, it detects the 
avialbale wifi networks and automatically stablishes a connection with 
mine.

> Can you read this thread for more ideas:  
> http://ubuntuforums.org/archive/index.php/t-1604665.html ?

I'm not sure what you want me to try... rfkill seems to be right and 
"modprobe -r -f hp_wmi" causes no effect. OTOH, there is no wired cable 
attached to the netbook.

> Let me know how this works out, if unsuccessful we'll have to dig a bit  
> deeper.
>
> Thanks, Roland.

Thanks for the tips.

Greetings,

-- 
Camaleón 

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="lsmod.txt"

root@stt300:~# lsmod
Module                  Size  Used by
nls_utf8               12416  1 
nls_cp437              12417  1 
vfat                   17078  1 
fat                    44609  1 vfat
sg                     21564  0 
usb_storage            35164  1 
uas                    13099  0 
acpi_cpufreq           12865  1 
mperf                  12421  1 acpi_cpufreq
cpufreq_powersave      12422  0 
cpufreq_stats          12758  0 
cpufreq_userspace      12520  0 
parport_pc             22059  0 
ppdev                  12651  0 
cpufreq_conservative    12987  0 
lp                     12894  0 
parport                27241  3 parport_pc,ppdev,lp
bnep                   17301  2 
rfcomm                 28700  0 
bluetooth              94736  10 bnep,rfcomm
crc16                  12327  1 bluetooth
binfmt_misc            12880  1 
uinput                 12953  1 
fuse                   56331  1 
loop                   17866  0 
arc4                   12418  2 
uvcvideo               56927  0 
videodev               61530  1 uvcvideo
media                  13692  2 uvcvideo,videodev
joydev                 17006  0 
i915                  294451  2 
drm_kms_helper         22688  1 i915
brcmsmac              489116  0 
drm                   129806  3 i915,drm_kms_helper
brcmutil               13187  1 brcmsmac
pcspkr                 12515  0 
i2c_algo_bit           12722  1 i915
i2c_i801               12670  0 
i2c_core               19141  6 videodev,i915,drm_kms_helper,drm,i2c_algo_bit,i2c_i801
hp_wmi                 13121  0 
evdev                  12995  16 
sparse_keymap          12707  1 hp_wmi
mac80211              165768  1 brcmsmac
snd_hda_codec_idt      44757  1 
uhci_hcd               22275  0 
battery                12957  0 
ehci_hcd               35401  0 
ac                     12552  0 
r8169                  37326  0 
psmouse                46216  0 
serio_raw              12734  0 
cfg80211              112970  2 brcmsmac,mac80211
power_supply           13283  2 battery,ac
wmi                    13051  1 hp_wmi
mii                    12595  1 r8169
usbcore               104234  6 usb_storage,uas,uvcvideo,uhci_hcd,ehci_hcd
snd_hda_intel          21691  1 
snd_hda_codec          58364  2 snd_hda_codec_idt,snd_hda_intel
snd_hwdep              12936  1 snd_hda_codec
snd_pcm                53315  2 snd_hda_intel,snd_hda_codec
snd_seq                39539  0 
snd_timer              22027  2 snd_pcm,snd_seq
snd_seq_device         12985  1 snd_seq
snd                    38562  10 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device
soundcore              12992  1 snd
video                  17475  1 i915
processor              27382  3 acpi_cpufreq
button                 12810  1 i915
rfkill                 18522  5 bluetooth,hp_wmi,cfg80211
snd_page_alloc         12899  2 snd_hda_intel,snd_pcm
crc_ccitt              12331  1 brcmsmac
reiserfs              176777  1 
sd_mod                 35493  5 
crc_t10dif             12332  1 sd_mod
ahci                   20897  2 
libahci                18231  1 ahci
libata                133339  2 ahci,libahci
scsi_mod              135178  5 sg,usb_storage,uas,sd_mod,libata
thermal                13138  0 
thermal_sys            17677  3 video,processor,thermal



--oyUTqETQ0mS9luUI--
