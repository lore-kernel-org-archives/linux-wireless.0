Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61799 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2GOXNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 19:13:18 -0400
Received: by wibhq12 with SMTP id hq12so1953967wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jul 2012 16:13:17 -0700 (PDT)
Message-ID: <50034EB7.8070309@nunof.eu> (sfid-20120716_011322_945133_EE43F202)
Date: Mon, 16 Jul 2012 00:13:59 +0100
From: Nuno Ferreira <self@nunof.eu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: Problem with hostapd and ath5k silently dropping STAs requests
References: <5002D653.6000701@nunof.eu>
In-Reply-To: <5002D653.6000701@nunof.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Just to update this call for help.

I've misunderstood the meaning of the versions in compat-wireless. I 
thought the version of the package was a reference to the kernel to 
which it could be applied and not the version of the wireless stack that 
it provided, hence I had applied the same wireless software level that I 
already had in my 2.6.35 kernel.

With the help of the people in IRC, I fixed this and I now have the 
compat-wireless-3.5-rc5-1 version. I have just managed to have the AP 
capabilities I wanted with this HW. My only known problem is that I 
cannot rmmod the ath5k without crashing the kernel. If I can capture the 
crash, I'll send it later.

When building/installing the compat-wireless I have this problem that I 
don't know if it's the cause of the later crash.

DEPMOD  2.6.35.8+
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/compat/compat.ko 
needs unknown symbol led_classdev_unregister
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/drivers/net/wireless/ath/ath5k/ath5k.ko 
needs unknown symbol led_classdev_register
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_unregister
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_blocked
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_destroy
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_resume_polling
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_pause_polling
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_set_hw_state
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_alloc
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_register
WARNING: 
../output//lib/modules/2.6.35.8+/extra/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/compat-wireless-3.5-rc5-1/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_set_sw_state
make: Leaving directory 
`/SOURCES/git/sglc2ip/public/eoskernel26-2.6.35/upstream/build-release'

Cheers,
Nuno

On 07/15/2012 03:40 PM, Nuno Ferreira wrote:
> Hello,
>
> Sorry for cross-posting but I'm not really sure about where the 
> problem is, ath5k or hostapd.
>
> I'm having problems using a Ubiquiti Networks XR5 (168c:001b, which is 
> reported working on 
> http://wireless.kernel.org/en/users/Drivers/ath5k#Supported_PCI_IDs 
> and http://www.wikidevi.com/wiki/Ubiquiti_Networks_XR5) in a custom 
> Linux distribution.
>
> It's based on kernel 2.6.35 (I cannot change this, although I can take 
> patches) and I've tried hostapd-0.7.3 and hostapd-1.0. My distribution 
> has no udev and I'm embedding db.txt for country regulatory domain 
> control.
>
> The device seems to be properly detected by the kernel. I'm currently 
> unable to have the hostap set channel and frequency but it seems that 
> I can set it first through iwconfig and use the channel=0 or 
> channel=acs_survey in hostapd.conf.
>
> iwconfig reports the device to be in master mode, on acceptable 
> frequency and channel (hw_mode=a, 5Ghz).
>
> Running the hostapd in debug mode (-dd), hostapd reports a flow of 
> probe requests sent by STAs but nothing else, not even ACKing them...
>
> I've also tested compat-wireless-2.6.35 but the results are the same. 
> I have some warnings when building compat-wireless (see attached) but 
> I'm not sure they are sufficient reason, at least "rfkill list" and 
> hostapd-1.0 (that depends on rfkill) still work.
>
> Two extra notes:
> - The kernel has some patches not related to wireless, the only patch 
> I've added to net/wireless/sysfs.c was a (slightly changed) patch from 
> Ben Greear  - 
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/57521 - 
> to add the name attribute to the sysfs that hostapd-1.0 needs.
>
> - Had no problems with hostapd-0.7.3 but hostapd-1.0 seems to depend 
> on libnl-1.x (nl80211_handle_alloc) so I had to go back to this one.
>
> I'm attaching information that I believe it's relevant. Please let me 
> know about any additional information you need.
>
> Any help would be highly appreciated, since I'm kind of blocked right 
> now.
>
> TIA,
> Nuno


