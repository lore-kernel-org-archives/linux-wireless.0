Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:1675 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYHFTCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:02:48 -0400
Message-ID: <4899F540.8050409@wpkg.org> (sfid-20080806_210253_315102_DCD21FEF)
Date: Wed, 06 Aug 2008 21:02:24 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org>	 <1217967177.3603.60.camel@johannes.berg> <4898CBF9.6030606@wpkg.org> <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com>
In-Reply-To: <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:

(...)

>> - doesn't work with prism54.ko module (similar messages to
>> http://marc.info/?l=linux-wireless&m=120250829717134&w=2)
> 
> We need more details, or do you get *exactly* the same error messages?
> 
> "Out of memory, cannot handle oid" comes up after a failed kmalloc()
> while trying to handle an interrupt and management frame (not 802.11
> frame) from the firmware. From that archived mailing list though the
> oid 0x080002ff is mentioned and... well prism54 doesn't know what that
> is. I wonder if the firmware is triggering random interrupts with
> bogus oids.
> 
> If you can provide a complete log it can help. Also in your previous
> posts I see you mentioned you were working with different firmwares.
> 1.0.4.3.arm should *only* be used with prism54. You may also want to
> try an older firmware version than 1.0.4.3.arm, this one came from
> 3com cards.

Is older firmware available anywhere online?

This is a complete log (kernel outputs pasted below each command, kernel 
used is 2.6.25.12 with OpenWRT patches), firmware used is 1.0.4.3.arm - 
messages are essentially the same as the last time I tried with 2.6.23.x:

# modprobe prism54
Loaded prism54 driver, version 1.2
PCI: Fixing up device 0000:00:02.0

# dmesg -c
Loaded prism54 driver, version 1.2
PCI: Fixing up device 0000:00:02.0


# ifconfig eth2 up
eth2: Out of memory, cannot handle oid 0x030002ff
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=10000002 err=-145
eth2: Out of memory, cannot handle oid 0x00000012
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=12000005 err=-145
eth2: Out of memory, cannot handle oid 0x07000012
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff020003 err=-145
eth2: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(
SIOCSIFFLAGS: Connection timed out

# dmesg -c
eth2: resetting device...
eth2: uploading firmware...
eth2: firmware version: 1.0.4.3
eth2: firmware upload complete
eth2: Out of memory, cannot handle oid 0x030002ff
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=10000002 err=-145
eth2: Out of memory, cannot handle oid 0x00000012
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=12000005 err=-145
eth2: Out of memory, cannot handle oid 0x07000012
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff020003 err=-145
eth2: mgt_commit: failure
eth2: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(



-- 
Tomasz Chmielewski
http://wpkg.org

