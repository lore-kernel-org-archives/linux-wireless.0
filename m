Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:59467 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbZIJS4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 14:56:16 -0400
Message-ID: <4AA94BAA.1070605@redfish-solutions.com>
Date: Thu, 10 Sep 2009 11:55:38 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jon.fairbairn@cl.cam.ac.uk,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: AP: ath5k + hostapd occasionally sulks
References: <4AA69A0D.3040608@redfish-solutions.com> <b6c5339f0909090600o267ae376o432cb36b912b7c2a@mail.gmail.com> <4AA7DB6C.9060207@redfish-solutions.com>
In-Reply-To: <4AA7DB6C.9060207@redfish-solutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip Prindeville wrote:
> Bob Copeland wrote:
>   
>> On Tue, Sep 8, 2009 at 1:53 PM, Philip Prindeville
>> <philipp_subx@redfish-solutions.com> wrote:
>>   
>>     
>>> I pulled compat-wireless from GIT last night (or about 1:30am mountain,
>>> really) and rebuilt a 2.6.27.29 kernel.
>>>
>>> I'm seeing a lot of:
>>>
>>> Sep  8 11:44:09 pbx user.err kernel: ath5k phy0: no further txbuf available, dropping packet
>>>
>>>
>>> one every 10 seconds, in fact.  This is with an Engenius EMP-8062+ card:
>>>     
>>>       
>> Ok, the timing information is useful.  This is probably something (beacon
>> sending?) racing with the periodic calibration, which temporarily stops
>> all of the tx traffic and frees the tx buffers, then starts it all up
>> again.  In short, apart from the logging this shouldn't cause any
>> problems, but we should probably disable the beacon tasklet during this
>> time.
>>   
>>     
>
> Alas it is causing problems.  I have a Windows 7 client with an Atheros
> card (I forget which... it's the mini-PCIe card that comes with Zotac
> ION mini-itx motherboards).
>
> I either can't associate, or associate but don't get a DHCP address or
> don't pass traffic... I forget which.
>
> I can do more testing tomorrow...
>   
>> If this only appeared all of a sudden in recent compat snapshots, it
>> would be useful to know the last one that worked normally.
>>   
>>     
>
> I could walk it backwards, I suppose...  2009-08-23 was definitely
> working with an 9K board.
>
> I've not tried it with a 5K board (I'm not at this location very often).
>   

FYI:  The Windows 7 box associates and runs just fine with 9K driver
with 2009-09-07.  So it seems to be an issue with the 5K driver.

I'll set up a second WAP with a 5K card...

-Philip

>
>   
>>> I'll probably have to reboot regularly, since this is on an embedded box
>>> with limited CF filesystem, and I can't overflow my /var partition...
>>>     
>>>       
>> Ouch.  For now, just take it out or demote it to debug.
>>
>> As for the original problem, I don't know offhand why a large download
>> would trigger a cascade of these errors.  The best way to track it down
>> is to try to come up with a case that reproduces it and sprinkle printks
>> throughout the driver, especially when we free and allocate the tx
>> buffers.
>>
>>   
>>     

