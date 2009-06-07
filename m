Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52265 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZFGR0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:26:14 -0400
Received: by bwz9 with SMTP id 9so2576147bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 10:26:15 -0700 (PDT)
Message-ID: <4A2BF833.1050906@tuffmail.co.uk>
Date: Sun, 07 Jun 2009 18:26:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243885494.3015.29.camel@localhost.localdomain>	 <4A24559D.7010201@tuffmail.co.uk>	 <1243928308.3192.38.camel@localhost.localdomain>	 <1243929706.20064.7.camel@johannes.local>	 <1243930703.3192.59.camel@localhost.localdomain>	 <20090603040315.GA10464@khazad-dum.debian.net>	 <1244008652.4145.7.camel@localhost.localdomain>	 <20090603213340.GB22809@khazad-dum.debian.net>	 <1244088806.4145.24.camel@localhost.localdomain>	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>	 <20090607125715.GC3340@khazad-dum.debian.net> <1244394963.12956.1.camel@johannes.local>
In-Reply-To: <1244394963.12956.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-06-07 at 09:57 -0300, Henrique de Moraes Holschuh wrote:
>
>   
>>>  1) remove rfkill_set_global_sw_state()
>>>  2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
>>> registration, setting a flag.
>>>  3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
>>> events, tho it may as well be set in all events)
>>>  4) rfkill-input preserves existing behaviour - *if enabled* - by
>>> initializing the global state from individual devices which have NVS.
>>> (As before, each _type_ of rfkill device has its own global state).
>>>  5) rfkill devices with NVS will have their current state preserved,
>>> so long as the global state has not yet been set (by userspace or by
>>> rfkill-input).  Of course userspace can change the state in response
>>> to the device being added.
>>>       
>
>   
>> Let's do it :-)
>>     
>
>
> Alan, you're right in that we currently overwrite devices with the
> global state upon registration. My suggestion would be to not do that
> when set_sw_state() has been called on the device before it was
> registered, by simply keeping track of that. Anyone want to propose a
> patch?
>
> johannes
>   

I'll have a go.  It seems within my abilities and I have hardware to
test it on.  What could possibly go wrong :-).

I'll try to do it in one swoop, get rid of set_global_sw_state() and
convert tp-acpi as well as eeepc-laptop.

Thanks
Alan
