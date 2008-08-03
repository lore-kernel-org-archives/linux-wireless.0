Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:54020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYHCPtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 11:49:01 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1773726rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 08:49:00 -0700 (PDT)
Message-ID: <1ba2fa240808030849g3110cfefo3de65d3ae3000273@mail.gmail.com> (sfid-20080803_174907_074235_102C0903)
Date: Sun, 3 Aug 2008 18:49:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <20080803135229.GG12118@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com>
	 <20080803035559.GB6053@khazad-dum.debian.net>
	 <1ba2fa240808022303i4d330023i74f3cbb7e08083eb@mail.gmail.com>
	 <20080803135229.GG12118@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 4:52 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 03 Aug 2008, Tomas Winkler wrote:
>> At least from iwlwifi perspective killing radio is not the same
>> operation as shutting down the card.
>
> It almost never is.  Which is why I said we should not bother if nobody
> needs that.
>
>> The intention is different if nothing it's really redundant operation
>
> On proper drivers that do proper power management? Certainly :-)
>
>> > RFKILL is not about tracking, it is about *controlling*.
>>
>>  I think driver controls the radio why need to add another entity for
>> that. I don't like this definition, But that's just wording I hope.
>
> All the radio-is-allowed-to-transmit decisions are rfkill's.  The driver is
> not allowed to override those.  This is done to present a uniform behaviour
> and interface to the system's user (and any instance of rfkill doing
> something the user wouldn't expect to the radio is to be considered a major
> bug).  rfkill is supposed to represend the will of the system's user
> regarding permission to transmit energy out of wireless transmitters.

May point is that there are radio event out of scope rfkill so the
driver although obey rfkill system
requests but rfkill switch doesn't control the radio, the driver does.
 But it's really just point of view.

>
> Not even WoWL is an exception, if your radio is blocked before suspend, you
> are not allowed to enable the transmitter [to get WoWL to work -- I sure
> hope this is not necessary, but it could be].  I'd expect a printk
> complaining about it, though :-)
>
>> I rather remove it, If the driver has D3 operation it should move card
>> to operation
>
> Sure.  I was wondering about drivers that *don't* have it, if any, out of
> the potential set of drivers that should be using rfkill (it is not a matter
> of those who are using rfkill right now).

I think we are aligned in general.
Thanks
Tomas
