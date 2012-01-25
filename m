Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:34146 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2AYNCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 08:02:19 -0500
Message-ID: <4F1FFC87.3060206@01019freenet.de> (sfid-20120125_140234_434159_6B78848A)
Date: Wed, 25 Jan 2012 13:58:47 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/4] rt2800usb: remove PWR_PIN_CFG=0x3
 during init
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com> <1327410549-4714-4-git-send-email-sgruszka@redhat.com> <201201241737.q0OHbmX5003698@mail.maya.org> <20120125095407.GA3406@redhat.com>
In-Reply-To: <20120125095407.GA3406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka schrieb:
> Hello
> 
> On Tue, Jan 24, 2012 at 06:37:45PM +0100, Andreas Hartmann wrote:
>> Stanislaw Gruszka schrieb:
>>> This seems to be only needed as workaround for hardware problem on 
>>> PCI devices.
>>
>> I tested this series (with all other resent patches applied) against a
>> rt3572usb based device (Linksys WUSB600N) on to different machines
>> (64bit smp (linux 3.2.1) and 32bit single core (linux 2.6.37.6)). I
>> couldn't see any functional change. Unfortunately it's as bad as
>> always :-(.
>>
>> But one thing is new: I'm getting now these errors in messages (with
>> kernel 3.2.1) in the moment of the stall (which never stops until the
>> module is unloaded (or I didn't display enough patience)):
>>
>>
>> Jan 24 18:10:23 nb kernel: [  798.289036] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
> This is write to BBP_CSR_CFG. I don't know, which patch is is responsible
> for that error (patch4 looks most suspicious), can you check those 4 patches
> one by one, and tell us which is causing this error? 

I removed Patch 1 and 4 - the problem didn't change. I think it's not
patch related, but system related: This was the first time, I tested
with this notebook (because compiling is much more fast :-)) and to get
more timing issues: this notebook is a Core i5 (the other was a
CeleronM). Besides that, there is another kernel version (3.2 vs.
2.6.37.6) and a completely new compat-wireless.

But I can say one more thing:

If this error above came up, the device isn't detected any more. Even
reloading of the complete wireless stack is useless:

11329.157039] cfg80211: Calling CRDA to update world regulatory domain
[11329.164191] cfg80211: World regulatory domain updated:
[11329.164200] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[11329.164202] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[11329.164204] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[11329.164206] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[11329.164208] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[11329.164209] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[11329.246554] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request
0x07 failed for offset 0x0580 with error -19.
[11329.246585] phy0 -> rt2800_init_eeprom: Error - Invalid RT chipset
detected.
[11329.246590] phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate
device.
[11329.246688] usbcore: registered new interface driver rt2800usb
[11329.246863] usb 2-1.6: USB disconnect, device number 4


You have to replug the device to get it detected again.

Some more details about what is concretely broken (tested with netperf):

AP -> STA 	2.4 MBit/s (if it doesn't stall)
STA -> AP	doesn't work at all

BTW: the performance should be at this location about 65 MBit/s
(AP->STA) or 55 MBit/s (STA-AP).


Well, I think, that the device is just overrun. The USB-handling looks
really odd. See here:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-November/004278.html


Kind regards,
Andreas
