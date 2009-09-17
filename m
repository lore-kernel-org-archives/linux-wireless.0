Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53433 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916AbZIQQLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 12:11:55 -0400
Date: Thu, 17 Sep 2009 18:11:54 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Bing Zhao <bzhao@marvell.com>, Dan Williams <dcbw@redhat.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for
 SD8385/SD8686/SD8688
Message-ID: <20090917161154.GA877@Chamillionaire.breakpoint.cc>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
 <45e8e6c40909151641o423cbc70y22033061505661b6@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F704306DB9CFDB7@SC-VEXCH1.marvell.com>
 <45e8e6c40909161347l23caaf4ct14d4ef7b416b3387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <45e8e6c40909161347l23caaf4ct14d4ef7b416b3387@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Andrey Yurovsky | 2009-09-16 13:47:48 [-0700]:

>> Some information (such as the interface name and path) in README file is out of date. We just copy-and-paste it for the new deepsleep command. We need a separate patch to clean up the REAME file and keep it up to date.
>
>Ok.  Either way, this is another out-of-band interface (regardless of
>if it's debugfs or sysfs).  That said, I believe that debugfs should
>be used for debugging, not for configuring driver/device features like
>these.
I agree on this. Debugfs is for debug only and should stay that way.
What do other driver in regard to this? I hardly belive that the
libertas driver is the only "deep sleep" user.

>>> Deep sleep seems to pretty much "turn off" the wifi card (as far as
>>> the user is concerned) so how about a simpler approach: enter deep
>>> sleep when the interface is brought down (ifconfig wlanN down) and
>>> exit deep sleep when it's brought up. ?Do this only when deep sleep is
>>> supported/possible. ?Alternately, maybe this belongs as an rfkill
>>> feature?
>>
>> Entering/exiting deep sleep doesn't have to depend on wlanN interface's up and down. User can still put the chip into sleep when wlanN is up. And, with auto deep sleep feature, the driver automatically wakes the chip up for sending user commands (for example, scan) and put the chip back to sleep after certain time period of inactivity. The deepsleep command through debugfs interface provides the flexibility of deep sleep options.
>>
>> The rfkill shuts down the RF transmitter of the device but most of other modules may be still functioning. The deep sleep shuts down most of the modules (including the RF) on the chip to save as much power as possible.
>
>It seems that when the device is in deep sleep, it's effectively
>"turned off" as far as the user is concerned.  That seems really
>similar to "ifconfig down" or rfkill, does the user really care about
>anything beyond that?  I understand that it's possible to control this
>feature independently of either of those functions, but is it ever
>necessary?  If not, it would be great to just integrate it into one
>(or both) of these already standard network interface semantics and
>not introduce a whole new configuration parameter.

iwconfig has an interface for this I think:
|interface power {period N|timeout N|saving N|off}

>From what I see in the man page it covers pretty much what you wrote in
the Readme file. So it looks like like there is your flexible interface
you've been looking for :)

>  -Andrey
>
>> Regards,
>>
>> Bing

Sebastian
