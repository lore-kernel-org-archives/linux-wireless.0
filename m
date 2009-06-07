Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63265 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZFGP1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:27:30 -0400
Received: by bwz9 with SMTP id 9so2534245bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 08:27:30 -0700 (PDT)
Message-ID: <4A2BDCB7.7060104@tuffmail.co.uk>
Date: Sun, 07 Jun 2009 16:28:55 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain> <20090603040315.GA10464@khazad-dum.debian.net> <1244008652.4145.7.camel@localhost.localdomain> <20090603213340.GB22809@khazad-dum.debian.net> <1244088806.4145.24.camel@localhost.localdomain> <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com> <20090607125715.GC3340@khazad-dum.debian.net>
In-Reply-To: <20090607125715.GC3340@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Sun, 07 Jun 2009, Alan Jenkins wrote:
>   
>>  1) remove rfkill_set_global_sw_state()
>>  2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
>> registration, setting a flag.
>>  3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
>> events, tho it may as well be set in all events)
>>  4) rfkill-input preserves existing behaviour - *if enabled* - by
>> initializing the global state from individual devices which have NVS.
>> (As before, each _type_ of rfkill device has its own global state).
>>  5) rfkill devices with NVS will have their current state preserved,
>> so long as the global state has not yet been set (by userspace or by
>> rfkill-input).  Of course userspace can change the state in response
>> to the device being added.
>>     
>
> I can agree to that, it will avoid the regression I have been
> complaining about, and seems to address the major complaints against
> what we have now...
>   

Yeah, I hope it avoids the objections about NVS in /dev/rfkill. We avoid 
the separate NVS operation. And it exports the NVS state through the 
specific device it comes from, rather than exporting it as a global state.

So userspace gets more specific information; at the same time the 
interface is simpler because the information comes in a single message, 
and it's less prescriptive because it doesn't push the idea of global 
state(s) quite so much.

> I think it should probably be enhanced (it doesn't have to be enhanced
> _now_, however) to let the core call back into NVS-providing drivers to
> checkpoint NVS state.  But that's not something I feel strongly about.
>   

Ok. I think that feature would be subject to further debate / 
clarification. So I will ignore it and code up the basics outlined above 
:-).

> Otherwise, the driver will checkpoint to NVS whatever is the state of
> its rfkill device, which could have been changed outside of the global
> scope.  While that's exacly what we do right now, it is arguably not the
> best way to go about it (i.e. it is broken).
>
>   
>> Comments?
>>     
>
> Let's do it :-)
>   

Cool :-). I'll see what I can do.

Alan

