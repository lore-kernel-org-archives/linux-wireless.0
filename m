Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46728 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2FHPEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 11:04:14 -0400
Received: by qadb17 with SMTP id b17so739991qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 08:04:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339167160.4901.0.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<1339094215.4630.7.camel@jlt3.sipsolutions.net>
	<1339102567.4630.8.camel@jlt3.sipsolutions.net>
	<4FD11B47.10002@lwfinger.net>
	<CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com>
	<1339136879.5832.1.camel@jlt3.sipsolutions.net>
	<1339137689.5832.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
Date: Fri, 8 Jun 2012 17:04:12 +0200
Message-ID: <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com> (sfid-20120608_170417_776527_8C55F83B)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 4:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 15:49 +0200, Andre Heider wrote:
>
>> > http://p.sipsolutions.net/854d460da251f9d6.txt
>>
>> Sorry, still not loading any firmware.
>
> So you're going to have to tell me what happens :-)

Well, nothing ;)

I just see this in dmesg:

[    1.012107] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
[    1.018765] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
[    1.096506] ssb: chipcommon status is 0x0
[    1.105314] b43-phy0: Broadcom 4318 WLAN found (core revision 9)

Hence the device doesn't get up and there's no way for me to interact
with the system.

With my "return 0;" hack instead of your patch I get:

[    0.863883] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[    0.881444] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
data mode. Opts: (null)
[    0.897382] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
[    0.943958] devtmpfs: mounted
[    0.958308] Freeing unused kernel memory: 148k freed
[    0.996678] ssb: Sonics Silicon Backplane found on SDIO device mmc1:0001:1
<30>[    1.897025] udevd[111]: starting version 175
[    4.818395] Adding 152552k swap on /dev/mmcblk0p3.  Priority:-1
extents:1 across:152552k SS
[    4.932077] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    5.300479] EXT4-fs (mmcblk0p2): re-mounted. Opts: discard,errors=remount-ro
[    9.197482] b43-phy0: Loading OpenSource firmware version 410.31754
[    9.210490] b43-phy0: Hardware crypto acceleration not supported by firmware
[    9.224923] b43-phy0: QoS not supported by firmware

This is a kernel without module and initramfs support.

Regards,
Andre
