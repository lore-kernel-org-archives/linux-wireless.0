Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:52682 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYLROAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 09:00:48 -0500
Received: by qyk4 with SMTP id 4so455723qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 06:00:47 -0800 (PST)
Message-ID: <494A578A.7070803@cortland.com> (sfid-20081218_150052_340546_91D51492)
Date: Thu, 18 Dec 2008 09:00:42 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Keir <keirlawson@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: Mesh now completely broken on ath5k, latest git
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>	 <4947ABAF.9060205@cortland.com>	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com> <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>
In-Reply-To: <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keir wrote:
> Tried this, and I'm getting slightly odd results.  The two nodes
> running with these lines commented out can see the node whose code is
> previous to the PCU patch, but they cant see each other.  Also the
> other node can see both of them... very strange.
>
> Cheers
>
> Keir
>
> 2008/12/17 Nick Kossifidis <mickflemm@gmail.com>:
>   
>> 2008/12/16 Andrey Yurovsky <andrey@cozybit.com>:
>>     
>>> Hi Keir.  What type of Atheros-based card are you using?  How many
>>> antennas do you have connected?  If I understand things correctly, the
>>> PCU code regression (with respect to mesh and maybe AP and IBSS) has
>>> to do with having one antenna hooked up when your hardware also has an
>>> AUX antenna connector.  If you have only one antenna, can you please
>>> plug in a second one and try again (before and after the commit in
>>> question)?  I will try to do the same test here.  More details from
>>> Nick were posted here:
>>> http://marc.info/?l=linux-wireless&m=122771338021489&w=2
>>>
>>>       
>> To summarize, the following code on base.c is the problem...
>>
>> 1955                 /*
>> 1956                  * Switch antenna every 4 beacons if txantenna is not set
>> 1957                  * XXX assumes two antennas
>> 1958                  */
>> 1959                 if (antenna == 0)
>> 1960                         antenna = sc->bsent & 4 ? 2 : 1;
>>
>> ...we should always set 0 on tx descriptor for the default scenario to
>> work. Can you please comment this out and see if it works ?
>>
>> --
>> GPG ID: 0xD21DB2DB
>> As you read this post global entropy rises. Have Fun ;-)
>> Nick
>>
>>     
I did a binary chop on the pcu patch. Reverting this part of the patch 
restores ap and mesh beaconing. I've no idea why.

77: +               else
78: +                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, 
AR5K_CFG_ADHOC);

Steve

