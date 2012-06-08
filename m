Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42533 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231Ab2FHPiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 11:38:24 -0400
Received: by gglu4 with SMTP id u4so1356676ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 08:38:23 -0700 (PDT)
Message-ID: <4FD21C6B.5000402@lwfinger.net> (sfid-20120608_173831_758956_334580B4)
Date: Fri, 08 Jun 2012 10:38:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andre Heider <a.heider@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?B?TWljaGFlbCBCw7xz?= =?UTF-8?B?Y2g=?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i]
 >= n_queues))
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com> <1339014959.4523.0.camel@jlt3.sipsolutions.net> <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com> <1339053364.4517.0.camel@jlt3.sipsolutions.net> <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com> <20120607180325.7752b3c0@milhouse> <1339094215.4630.7.camel@jlt3.sipsolutions.net> <1339102567.4630.8.camel@jlt3.sipsolutions.net> <4FD11B47.10002@lwfinger.net> <CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com> <1339136879.5832.1.camel@jlt3.sipsolutions.net> <1339137689.5832.2.camel@jlt3.sipsolutions.net> <CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com> <1339167160.4901.0.camel@jlt3.sipsolutions.net> <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com> <1339168452.5748.0.camel@jlt3.sipsolutions.net> <1339168600.5748.2.camel@jlt3.sipsolutions.net> <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
In-Reply-To: <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2012 10:25 AM, Andre Heider wrote:
> On Fri, Jun 8, 2012 at 5:16 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Fri, 2012-06-08 at 17:14 +0200, Johannes Berg wrote:
>>> On Fri, 2012-06-08 at 17:04 +0200, Andre Heider wrote:
>>>
>>>>>>> http://p.sipsolutions.net/854d460da251f9d6.txt
>>>>>>
>>>>>> Sorry, still not loading any firmware.
>>>>>
>>>>> So you're going to have to tell me what happens :-)
>>>>
>>>> Well, nothing ;)
>>>>
>>>> I just see this in dmesg:
>>>>
>>>> [    1.012107] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
>>>> [    1.018765] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
>>>> [    1.096506] ssb: chipcommon status is 0x0
>>>> [    1.105314] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
>>>>
>>>> Hence the device doesn't get up and there's no way for me to interact
>>>> with the system.
>>>
>>> Ok, well, bugger :-)
>>>
>>> Can you go to main.c and print out the return value of
>>> ieee80211_register_hw()? I have a feeling that's where the failure is
>>> though I don't really know why.
>>
>> No, wait, I do know why. Sorry!
>>
>> Try this new version of the patch:
>> http://p.sipsolutions.net/3f75b09af68fd455.txt
>>
>> If my hunch is right then we need to figure out how to not allow
>> off-channel or something.
>
> Now we do have a firmware, but still no working device ;)
>
> [    0.553905] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
> [    0.561166] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
> [    0.568378] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
> [    0.582703] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09,
> vendor 0x4243)
> [    0.597831] ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
> [    0.613445] ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
> [    0.629924] ssb: chipcommon status is 0x0
> [    0.638689] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
> [    0.651588] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
> data mode. Opts: (null)
> [    0.668126] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
> [    0.688275] devtmpfs: mounted
> [    0.698550] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
> [    0.709359] Freeing unused kernel memory: 148k freed
> [    0.719464] b43-phy0 debug: Found Radio: Manuf 0x17F, Version
> 0x2050, Revision 8
> [    0.775832] ssb: Sonics Silicon Backplane found on SDIO device mmc1:0001:1
> <30>[    1.691732] udevd[110]: starting version 175
> [    3.438357] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    4.274918] Adding 152552k swap on /dev/mmcblk0p3.  Priority:-1
> extents:1 across:152552k SS
> [    4.402116] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
> [    4.813161] EXT4-fs (mmcblk0p2): re-mounted. Opts: discard,errors=remount-ro
> [    8.880236] b43-phy0: Loading OpenSource firmware version 410.31754
> [    8.897893] b43-phy0: Hardware crypto acceleration not supported by firmware
> [    8.915844] b43-phy0: QoS not supported by firmware
> [    9.292779] b43-phy0 debug: Chip initialized
> [    9.312654] b43-phy0 debug: PIO initialized
> [    9.323317] b43-phy0 debug: QoS disabled
> [    9.512150] b43-phy0 debug: Wireless interface started
> [    9.654251] b43-phy0 debug: Adding Interface type 2
> [   11.371154] b43-phy0 ERROR: MAC suspend failed
> [   11.811166] b43-phy0 ERROR: MAC suspend failed
> [   12.235095] b43-phy0 ERROR: MAC suspend failed
> [   12.639094] b43-phy0 ERROR: MAC suspend failed
> [   13.043095] b43-phy0 ERROR: MAC suspend failed
> [   13.447165] b43-phy0 ERROR: MAC suspend failed
> [   13.851095] b43-phy0 ERROR: MAC suspend failed
> [   14.255095] b43-phy0 ERROR: MAC suspend failed
> [   14.655095] b43-phy0 ERROR: MAC suspend failed
> [   15.055095] b43-phy0 ERROR: MAC suspend failed
> [   16.383095] net_ratelimit: 2 callbacks suppressed
> [   16.389679] b43-phy0 ERROR: MAC suspend failed
> [   16.859094] b43-phy0 ERROR: MAC suspend failed
> [   17.207095] b43-phy0 ERROR: MAC suspend failed
> [   17.535095] b43-phy0 ERROR: MAC suspend failed
> [   21.863095] b43-phy0 ERROR: MAC suspend failed
> [   22.191095] b43-phy0 ERROR: MAC suspend failed
> [   22.527096] b43-phy0 ERROR: MAC suspend failed
> [   22.919095] b43-phy0 ERROR: MAC suspend failed
> [   23.319095] b43-phy0 ERROR: MAC suspend failed
> [   23.719094] b43-phy0 ERROR: MAC suspend failed
> [   24.119094] b43-phy0 ERROR: MAC suspend failed
> [   24.519095] b43-phy0 ERROR: MAC suspend failed
> [   24.919095] b43-phy0 ERROR: MAC suspend failed
> [   25.267095] b43-phy0 ERROR: MAC suspend failed
> [   27.207095] net_ratelimit: 4 callbacks suppressed
> [   27.210643] b43-phy0 ERROR: MAC suspend failed
> [   27.675094] b43-phy0 ERROR: MAC suspend failed
> [   28.139094] b43-phy0 ERROR: MAC suspend failed
> [   28.607095] b43-phy0 ERROR: MAC suspend failed
> [   28.951095] b43-phy0 ERROR: MAC suspend failed
> [   29.275094] b43-phy0 ERROR: MAC suspend failed
> [   33.615095] b43-phy0 ERROR: MAC suspend failed
> [   33.939095] b43-phy0 ERROR: MAC suspend failed
> [   34.275095] b43-phy0 ERROR: MAC suspend failed
> [   34.663095] b43-phy0 ERROR: MAC suspend failed
> [   35.059095] b43-phy0 ERROR: MAC suspend failed
> [   35.455095] b43-phy0 ERROR: MAC suspend failed
> [   35.851095] b43-phy0 ERROR: MAC suspend failed
> [   36.247095] b43-phy0 ERROR: MAC suspend failed
> [   36.643095] b43-phy0 ERROR: MAC suspend failed
> [   37.039095] b43-phy0 ERROR: MAC suspend failed
> [   39.087095] net_ratelimit: 4 callbacks suppressed
> [   39.089274] b43-phy0 ERROR: MAC suspend failed
> [   39.555111] b43-phy0 ERROR: MAC suspend failed
> [   40.023095] b43-phy0 ERROR: MAC suspend failed
> [   40.367094] b43-phy0 ERROR: MAC suspend failed
> [   40.691159] b43-phy0 ERROR: MAC suspend failed
> [   40.868103] b43-phy0 ERROR: Firmware watchdog: The firmware died!
> [   40.870979] b43-phy0: Controller RESET (Firmware watchdog) ...
> [   41.195093] b43-phy0 ERROR: MAC suspend failed
> [   41.198361] b43-phy0 debug: Wireless interface stopped
> [   42.204236] b43-phy0: Loading OpenSource firmware version 410.31754
> [   42.208043] b43-phy0: Hardware crypto acceleration not supported by firmware
> [   42.215386] b43-phy0: QoS not supported by firmware
> [   42.588772] b43-phy0 debug: Chip initialized
> [   42.603881] b43-phy0 debug: PIO initialized
> [   42.610060] b43-phy0 debug: QoS disabled
> [   42.794869] b43-phy0 debug: Wireless interface started
> [   42.818522] b43-phy0: Controller restarted
> [   45.107095] b43-phy0 ERROR: MAC suspend failed
> [   45.507095] b43-phy0 ERROR: MAC suspend failed
>
> I let it retry the load/die cycle >5 times, seems to repeat endlessly.
>

I got the same result as Andre when using open-source firmware - endless MAC 
suspend failures. It works OK with the proprietary fw, with or without a "qos=0" 
module parameter.

Larry


