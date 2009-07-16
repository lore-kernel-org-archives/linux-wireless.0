Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:39227 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442AbZGPWJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 18:09:52 -0400
Message-ID: <4A5FA52D.7030701@mandriva.org>
Date: Fri, 17 Jul 2009 01:09:49 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
References: <4A5D0374.5040702@mandriva.org>	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org> <1247672725.17896.1974.camel@rc-desk>
In-Reply-To: <1247672725.17896.1974.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre skrev:
> Thomas,
> 
> On Tue, 2009-07-14 at 15:45 -0700, Thomas Backlund wrote:
>> Johannes Berg skrev:
>>> On Wed, 2009-07-15 at 01:15 +0300, Thomas Backlund wrote:

>>>> --- cut ---
>>>> Bringing up interface wlan0:  RTNETLINK answers: Unknown error 132
>>>> RTNETLINK answers: Unknown error 132
>>> press your rfkill button.
>> I wish it was that simple :-(
>>
>> I already tried it, but it does not help...
>> I get no reaction what so ever from pressing it...
>>
>> The laptop is an Acer 5720G if that makes any difference...
>>
>> Could it be that rfkill has been broken for my laptop ?
>>
>> And why should I need to press rfkill now, when I didn't before ?
>> Has some kernel defaults changed since 2.6.30 series ?
> 
> Do you have debugging enabled? Does your logs contain anything useful?
> 

Nope.
Nothing gets logged when I press the rfkill...

I'd say that the rfkill rewrite killed my wireless :-(

Bluetooth works at it whould, but not the wireless

But now I have atleast found one way to get it working...

I've built the rfkill utility, and with it I can get the wireless working...

Here is the output when wireless works:
[root@tmb-laptop rfkill]# ./rfkill list
0: acer-wireless: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: acer-bluetooth: Bluetooth
	Soft blocked: yes
	Hard blocked: no
2: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

Pressing the rfkill button gets me this:
[root@tmb-laptop rfkill]# ./rfkill list
0: acer-wireless: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
1: acer-bluetooth: Bluetooth
	Soft blocked: yes
	Hard blocked: no
2: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: yes

And pressing it again gets this:
[root@tmb-laptop rfkill]# ./rfkill list
0: acer-wireless: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: acer-bluetooth: Bluetooth
	Soft blocked: yes
	Hard blocked: no
2: phy0: Wireless LAN
	Soft blocked: yes
	Hard blocked: no

And after that I cant get wireless back until I again do a:
./rfkill unblock 2
(works only when acer-wireless is no/no and Wireless LAN is yes/no)

Applying this patch:
[PATCH] rfkill: fix rfkill_set_states() to set the hw state
sent by Alan Jenkins does not help this issue either...

Any  suggestions how to fix the rfkill ?

--
Thomas
