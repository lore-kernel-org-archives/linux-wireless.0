Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59594 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755203Ab2DDB0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 21:26:36 -0400
Message-ID: <4F7BA34C.2030001@boundarydevices.com> (sfid-20120404_032640_043748_167A8DF9)
Date: Tue, 03 Apr 2012 18:26:36 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Gary Thomas <gary@mlbassoc.com>, linux-wireless@vger.kernel.org
Subject: Re: wl1271 watchdog interrupt
References: <4F6A7FD0.8090404@boundarydevices.com>  <4F71CDC7.2010207@mlbassoc.com> <1333355941.16990.23.camel@cumari>
In-Reply-To: <1333355941.16990.23.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/2/2012 1:39 AM, Luciano Coelho wrote:
> Hi,
>
> On Tue, 2012-03-27 at 08:25 -0600, Gary Thomas wrote:
>> On 2012-03-21 19:26, Troy Kisky wrote:
>>> Hi all
>>>
>>> We have a new board using the wl1271. As long as I keep it busy,
>>> everything is fine. But once it becomes idle I get,
>>> "wl12xx: ERROR watchdog interrupt received! starting recovery."
>>>
>>> Has this been seen by others?
>> I'm getting very similar problems and my messages to this list (and the
>> wl12xx maintainer) are now waiting for nearly two weeks for an answer.
>>
>> Can someone help with these wl12xx issues?
> Sorry for the delay, I've been busy traveling and on vacations in the
> past weeks.
>
>
>>> I'm using compat-wireless-2012-01-26 and my kernel is based on 3.0
>>>
>>> Other relevant log messages:
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> add wake up source irq 108
>>> wl12xx: loaded
>>> wl12xx: firmware booted (Rev 6.3.0.0.77)
>>> wlan0: authenticate with 00:12:17:31:67:e7 (try 1)
>>> wlan0: authenticated
>>> wlan0: associate with 00:12:17:31:67:e7 (try 1)
>>> wlan0: RX AssocResp from 00:12:17:31:67:e7 (capab=0x411 status=0 aid=3)
>>> wlan0: associated
>>> wlan0: moving STA 00:12:17:31:67:e7 to state 1
>>> wlan0: moving STA 00:12:17:31:67:e7 to state 2
>>> wlan0: moving STA 00:12:17:31:67:e7 to state 3
>>> wl12xx: Association completed.
>>>
>>> .......
>>> wl12xx: ERROR watchdog interrupt received! starting recovery.
>>> wl12xx: Reading FW panic log
>>> wl12xx: ERROR command complete timeout
> This is a firmware bug.  Can you please take the contents
> of /sys/bus/platform/drivers/wl12xx_driver/wl12xx/fwlog and send it to
> us so we can take a look at what's going on?
Sorry, it isn't a firmware bug. It was a configuration problem on my 
part. The defconfig
file I was using was enabling a TVOUT driver which this board doesn't 
have. When
the driver wanted to blank the screen, it was turning off my slow clock 
to my WL1271.

When the WL1271 later becomes idle, it goes into a low power state which 
depends upon
slow clock. So please tell your firmware guys, "never mind."
>> wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x23923
> This tells us where the PC was when the crash happened.  I'll ask our
> firmware team to analyze this.
"Never mind...."


Thanks
Troy

