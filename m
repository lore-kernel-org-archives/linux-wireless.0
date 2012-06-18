Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55346 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2FRXq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 19:46:56 -0400
Received: by lbbgm6 with SMTP id gm6so4995234lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 16:46:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be>
References: <4FDE1EF5.9030805@gmail.com> <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 19 Jun 2012 09:46:35 +1000
Message-ID: <CAGRGNgXaWHMi3xDygVAzDcm6qLnHPO2nXnidPW6K+e-v1=Hm3Q@mail.gmail.com> (sfid-20120619_014700_630299_8EFE5E1C)
Subject: Re: ath9k bug in country domain handling
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erwin,

On Mon, Jun 18, 2012 at 10:25 PM, Erwin Van de Velde
<erwin.vandevelde@gmail.com> wrote:
>
> The output I get is:
> [ 8.931463] ath: EEPROM regdomain: 0x0
> [ 8.931483] ath: EEPROM indicates default country code should be used
> [ 8.931502] ath: doing EEPROM country->regdmn map search
> [ 8.931526] ath: country maps to regdmn code: 0x3a
> [ 8.931544] ath: Country alpha2 being used: US
> [ 8.931561] ath: Regpair used: 0x3a
>
> As I see it, the regdomain is 00 and not US, so why does the ath9k driver
> decide to put me in the US? US should not be the default country code, but
> world reg domain. The preferred solution in my opinion is that the driver
> would require a regdomain to be given if it is not already set by the card.
> Choosing US as a default seems purely random .

No, US is the *default*. It's not just flipping a coin and choosing
one, it's choosing the default. Choosing the US as the default is
probably specified in the specification of the chipset by Atheros. (A
US-based company)

> It would make far more sense to
> have no restricions by default if no regdomain is given and require it as a
> parameter, so everyone can set it correctly to his correct domain. The current
> method not only disallows valid channels to be used, but can also allow for
> legally forbidden channels to be used, which could be even worse.

As I explained previously, the cards are tuned and configured for a
particular regulatory domain when they're manufactured. The driver
cannot assume that the card will be capable of complying with another
regulatory domain.

The cfg80211 regulatory code is trying to produce the best result it
can that both complies with the regulatory restrictions in force and
allows you to use your card. Producing a set of rules that are the
intersection of the US and Belgium restrictions is the best way to do
this. The card says it's in the US, you say you're in Belgium - the
intersection of the restrictions is the only way to satisfy both of
those regulatory requirements and ensure that the card is working as
required by whichever laws are in effect.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
