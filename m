Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dbservice.com ([213.239.204.14]:52766 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751729AbYAQBNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 20:13:25 -0500
Message-ID: <478EA984.50201@dbservice.com> (sfid-20080117_011330_999705_160296F4)
Date: Thu, 17 Jan 2008 02:04:04 +0100
From: Tomas Carnecky <tom@dbservice.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: led support in mac80211 and drivers
References: <478DF297.9020904@dbservice.com> <1ba2fa240801160832g611d5763gcb3d681353019d4f@mail.gmail.com> <478E465A.2030003@dbservice.com> <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com> <20080116200126.GA3164@tuxdriver.com>
In-Reply-To: <20080116200126.GA3164@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Jan 16, 2008 at 08:38:48PM +0200, Tomas Winkler wrote:
>> That
>>> driver switches between different modes based on bus->boardinfo.vendor.
>>> But where are the other modules needing this flexibility? Are they being
>>> developed in private by the companies that make the access points?
>>>
>> Different Laptop vendor and AP vendors. This information might be
>> written in many places, PCI subvendor, in EEROM etc sometimes it has
>> to be supplied from outside.

The question rather was: since there is really no user of the led 
infrastructure that needs the flexibility (the broadcom seems to have 
the leds on the same bus as the device itself) in the official kernel.. 
where are these drivers? Are they publicly available? Or are they in 
custom kernels? I can see the need for such infrastructure, but I don't 
see any actual users of it...

>>> I thought about having an 'ieee80211_activity_listener' that could
>>> subscribe to activity events of a ieee80211_hw device. One single
>>> callback that would be called when there's activity or if the state of
>>> the device has changed. Maybe something like this:
>>>
>>> int (*callback)(... *hw, u8 state, u8 type);
>>>
>>> where 'state' would be a bitmap of scanning/associated/etc and type the
>>> 'type' of activity (transmitting/receiving a frame). The callback then
>>> would decide which leds to activate and how (blinking or not etc). Does
>>> that sound better? At least it would be better than having to register
>>> three leds in each low-level driver ;)
>> I'm not sure it's such big deal to subscribe to led more problem is
>> that I cannot subscribe same led to different triggers
>> so need another level
>> mac80211     | driver
>> Led Trigger ->| Logical Led -> (LED LOGIC/MAPPING) ->  HW LED
>>                     |
>>
>> The problem here is that logic is already defined in Led pattern is
>> already defined int Led Trigger
>>
>> Problem with your approach I cannot reach LEDs that are not connected
>> to NIC's PCIe pins.
 >>
 >> Other options that uses your idea is
 >> mac80211        |  driver
 >> mac callback ->| (LED LOGIC) - Led Trigger - > Led

I see that the whole wireless led interaction is a delicate matter. It's 
not easy to understand it fully (in such short time - however hard I 
try). You wouldn't believe how many times I've rewritten this email ;)

Do you have any numbers about how many platforms have leds on a 
different bus than the wlan device? Are those notebooks or embedded 
devices? In case of notebooks, I assume linux doesn't support the leds 
there, since I haven't found any code in the kernel that would use the 
mac80211 led subsystem to receive led activity notifications.

The 4965 chip supposedly supports three leds, but my notebook (thinkpad 
x61t) only has one. Other notebooks/platforms may have two/three. I 
imagine implementing different led behaviour based on how many leds 
there are and other platform differences will require lots of code 
(platform detection etc). And thus getting the led code right for 
everyone is very difficult. Is that the reason why any of the iwlwifi 
led patches hasn't been applied yet?

In the iwl4965 driver, implementing led support wholly inside the driver 
itself seems possible. And platforms that have leds on a different bus 
still can make their own led-driver and use the mac80211 subsystem to 
receive led activity notifications. All but the broadcom wireless 
drivers implement led support is such way. So I think that's the way to go.

In essence, on platforms that have the radio device and leds on the same 
bus, it's actually easier to implement led support inside the driver and 
not using the mac80211 led subsystem. The driver has all the needed info 
to control the leds (device state etc). The mac80211 led subsystem is 
only useful for platforms where the leds are on a different bus.

I must apologize, there's nothing wrong with the mac80211 led subsystem, 
it does what it was designed for. It's the many iwlwifi led patches that 
gave me a bad impression that the mac80211 led subsystem was somehow 
needed for led support, what a shame :( I'm sorry for the noise.


tom

