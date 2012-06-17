Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45438 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050Ab2FQCQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 22:16:08 -0400
Received: by lahd3 with SMTP id d3so2844706lah.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 19:16:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425745.oeb9uPtGCl@sylvesterjr.cmi.ua.ac.be>
References: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be> <3396938.ZAv4RZqcUo@sven-desktop.home.narfation.org>
 <1425745.oeb9uPtGCl@sylvesterjr.cmi.ua.ac.be>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 17 Jun 2012 12:15:47 +1000
Message-ID: <CAGRGNgXO21GfXm02MigmUdeiYd5osnZVeDRLxz6LEyDCYy5Q+A@mail.gmail.com> (sfid-20120617_041613_311246_6604C3B1)
Subject: Re: ath9k bug in country domain handling
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Schrober <franzschrober@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erwin,

On Sat, Jun 16, 2012 at 7:51 AM, Erwin Van de Velde
<erwin.vandevelde@gmail.com> wrote:
> On Friday 15 June 2012 21:00:23 Schrober wrote:
>> On Wednesday 13 June 2012 13:17:49 Erwin Van de Velde wrote:
>> > Dear all,
>> >
>> > I have 802.11n cards with an atheros chipset with no default country
>> > domain. Upon initialization, crda is set to US domain, after which I try
>> > to change it to another domain, the driver only accepts further
>> > limitations: i.e. if a channel is allowed in the US but not in Belgium,
>> > it is disabled, but the other way round: if a channel is not allowed in
>> > the US, but is allowed in Belgium it is not enabled.
>>
>> That is not a bug, but something we call restriction.
>>
>
> What? It definitely is a bug, since it restricts something that should not be
> restricted in Belgium. I am talking about channels you are allowed to use in
> Belgium, which get disabled by the driver. How can this not be a bug?
> If I call crda for the BE domain, I expect to get _all_ channels that are
> allowed in Belgium, not just some.

There are two places where the country codes and their associated
restrictions come from:
1. The user, by saying "iw reg set XX" or having some other program
set that for them.
2. The driver, by asking the card which country it's been configured for.

The kernel regulatory framework then takes these two sets of
regulatory data, finds the intersection of them, and restricts the
channels and options available for the card based on that.

Why?

I'm not sure of the exact details, but I know that most wireless cards
are configured, by which I mean calibrated, adjusted and tuned to work
in a particular country. Some are configured for the entire world, but
most are configured for a single country's requirements. The driver
cannot assume that if it asks the card to do anything outside the
country it's been configured for, that it will perform predictably.
So, for example, if the driver asks your card to use a channel that is
outside the US's regulatory requirements, the driver cannot guarantee
that, even if it instructs the card how to use that channel correctly,
it will actually use that channel in a manner consistent with
Belgium's regulatory requirements.

The driver's behaviour when it encounters the unset regulatory
information on the card will be to use the default information for
that card. Which in this case is the US regulatory restrictions.

I hate to say it, but the issue here is *not* the driver itself. The
supplier of that card has not set it up correctly for Belgium, and the
driver is compensating for that as best as it can.

I have a similar card at home in Australia, it's configured for use in
China, and thankfully the intersection of China's and Australia's
regulatory requirements are such that I can use it for the purpose I
purchased it for.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
