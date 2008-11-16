Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:61264 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYKPSB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 13:01:29 -0500
Received: by yx-out-2324.google.com with SMTP id 8so904559yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2008 10:01:27 -0800 (PST)
Message-ID: <449c10960811161001h547a7ab0l937bba6bec9d46aa@mail.gmail.com> (sfid-20081116_190133_333904_AC2D115D)
Date: Sun, 16 Nov 2008 12:01:27 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <20081116165213.GC14126@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
	 <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
	 <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
	 <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com>
	 <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
	 <20081116162019.GA15851@hash.localnet>
	 <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com>
	 <20081116165213.GC14126@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2008 at 10:52 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Nov 16, 2008 at 10:38:39AM -0600, Dan McGee wrote:
>> On Sun, Nov 16, 2008 at 10:20 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> > As you can see, the modules think "phy0" should be at offset 164, but
>> > it's really at 160.
>>
>> > Also I noticed the original config had CONFIG_DYNAMIC_FTRACE=y, unfortunately
>> > turning that off didn't seem to change anything (hmm, I didn't get a build
>> > bug, was the breakage fixed in 2.6.27.y?)
>>
>> Note that HAVE is set if the architecture supports it; CONFIG_FTRACE
>> itself was turned off (and CONFIG_DYNAMIC_FTRACE is not even present):
>> $ grep FTRACE .config
>> CONFIG_HAVE_FTRACE=y
>> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> # CONFIG_FTRACE is not set
>
> Oh, you are right.  Thanks.  I probably won't be able to do any more
> testing today but I would suggest trying to turn off wireless-related
> options in the main kernel config and see if you can get it working
> (start with cfg80211 and its dependencies...)

The fun continues. If I rebuild the kernel with all wireless options
turned off except WIRELESS_EXT, then build compat-wireless, our module
appears to load without issues.

.config:
#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

dmesg:
atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
<<< boot stopped here, then I modprobed ath5k >>>
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:01:00.0: setting latency timer to 64
ath5k_pci 0000:01:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
wlan0: authenticate with AP 00:1c:10:21:f5:f4
wlan0: authenticated
wlan0: associate with AP 00:1c:10:21:f5:f4
wlan0: RX AssocResp from 00:1c:10:21:f5:f4 (capab=0x411 status=0 aid=3)
wlan0: associated

I had not seen this cfg80211 stuff before when modprobing. I also see
that cfg80211 is now loaded as a module- was the fact that it was
built into the kernel before causing all these problems? That would be
my strong suspicion, in which case this entire thread is really a bum
bug report, except that compat-wireless should enforce that cfg80211
is a module just like it currently enforces that for mac80211, saving
someone else this headache.

-Dan
