Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:9675 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409AbYHCWgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 18:36:35 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1859485rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 15:36:35 -0700 (PDT)
Message-ID: <1ba2fa240808031536n3c2d6171l191d5ec1c9321c7c@mail.gmail.com> (sfid-20080804_003640_789892_F115A7B3)
Date: Mon, 4 Aug 2008 01:36:35 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <20080803182521.GA23180@khazad-dum.debian.net>
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
	 <1ba2fa240808030849g3110cfefo3de65d3ae3000273@mail.gmail.com>
	 <20080803182521.GA23180@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 3, 2008 at 9:25 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 03 Aug 2008, Tomas Winkler wrote:
>> > All the radio-is-allowed-to-transmit decisions are rfkill's.  The driver is
>> > not allowed to override those.  This is done to present a uniform behaviour
>> > and interface to the system's user (and any instance of rfkill doing
>> > something the user wouldn't expect to the radio is to be considered a major
>> > bug).  rfkill is supposed to represend the will of the system's user
>> > regarding permission to transmit energy out of wireless transmitters.
>>
>> May point is that there are radio event out of scope rfkill so the
>> driver although obey rfkill system
>
> Err, no.  If it involves energy emission, if rfkill forbade it [which is to
> be taken as the user forbade it], the driver must not, EVER, cause it to
> happen.  There are no exceptions.

I didn't mean those kind of events :)  iwlwifi driver has proper FCC
certification.
>
> This is a safety thing, not a convenience thing.
>
>> > Sure.  I was wondering about drivers that *don't* have it, if any, out of
>> > the potential set of drivers that should be using rfkill (it is not a matter
>> > of those who are using rfkill right now).
>>
>> I think we are aligned in general.
>
> I may still have it as optional, but I will switch the default behaviour
> around.  It will likely be useful for someone, and it is less than 10 LOC.

I make an effort to remove  it's a mess.
Tomas
