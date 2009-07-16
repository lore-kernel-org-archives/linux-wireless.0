Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:59464 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579AbZGPXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:35:36 -0400
Message-ID: <4A5FB944.90709@mandriva.org>
Date: Fri, 17 Jul 2009 02:35:32 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
References: <4A5D0374.5040702@mandriva.org>	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org> <1247782731.31442.3.camel@johannes.local>
In-Reply-To: <1247782731.31442.3.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg skrev:
> On Fri, 2009-07-17 at 01:09 +0300, Thomas Backlund wrote:
> 
>> Nope.
>> Nothing gets logged when I press the rfkill...
>>
>> I'd say that the rfkill rewrite killed my wireless :-(
>>
>> Bluetooth works at it whould, but not the wireless
>>
>> But now I have atleast found one way to get it working...
>>
>> I've built the rfkill utility, and with it I can get the wireless working...
> 
> Thanks for the analysis!
> 
>> Here is the output when wireless works:
>> [root@tmb-laptop rfkill]# ./rfkill list
>> 0: acer-wireless: Wireless LAN
>> 	Soft blocked: no
>> 	Hard blocked: no
>> 1: acer-bluetooth: Bluetooth
>> 	Soft blocked: yes
>> 	Hard blocked: no
>> 2: phy0: Wireless LAN
>> 	Soft blocked: no
>> 	Hard blocked: no
> 
> Makes sense that it works at this point :)
> 
>> Pressing the rfkill button gets me this:
>> [root@tmb-laptop rfkill]# ./rfkill list
>> 0: acer-wireless: Wireless LAN
>> 	Soft blocked: yes
>> 	Hard blocked: no
>> 1: acer-bluetooth: Bluetooth
>> 	Soft blocked: yes
>> 	Hard blocked: no
>> 2: phy0: Wireless LAN
>> 	Soft blocked: no
>> 	Hard blocked: yes
> 
> So far so good. Your platform's soft-switch is wired to the card's hard
> kill line. Mind trying
> 
> 	./rfkill unblock 0
> 
> (or whatever ID the acer-wireless has) at this point to see what
> happens? I would hope it goes back to the working state.
> 

Nothing happends...

It does not change anything on either acer-wireless or phy0

--
Thomas
