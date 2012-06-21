Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49204 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2FUAXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 20:23:32 -0400
Received: by lbbgm6 with SMTP id gm6so1354529lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 17:23:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE24EF4.5010607@gmail.com>
References: <4FDE1EF5.9030805@gmail.com> <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be>
 <CAGRGNgXaWHMi3xDygVAzDcm6qLnHPO2nXnidPW6K+e-v1=Hm3Q@mail.gmail.com> <4FE24EF4.5010607@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Jun 2012 10:23:10 +1000
Message-ID: <CAGRGNgW=aRgFcugnOG7pxDNQ_5_omVvP7=AYxwNeePcfWido0Q@mail.gmail.com> (sfid-20120621_022335_637867_CC3B17DB)
Subject: Re: ath9k bug in country domain handling
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xose,

On Thu, Jun 21, 2012 at 8:30 AM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 06/19/2012 01:46 AM, Julian Calaby wrote:
>
>> As I explained previously, the cards are tuned and configured for a
>> particular regulatory domain when they're manufactured. The driver
>> cannot assume that the card will be capable of complying with another
>> regulatory domain.
>
>
> That's false.
>
> Atheros does not produce distinct chips for different countries or
> markets.

That's not what I meant.

I meant that the *card* not the *chip* is configured. It would be
incredibly wasteful for Atheros to produce different chips per market.

IIRC the card can sometimes be built / configured to work properly
within certain frequencies while disregarding the functionality of
others, much like how some hardware expects to be used with Windows
and fails utterly when Linux does things ever-so-slightly differently.
As I understand it, the country code stored in the EEPROM is a way of
making sure that the driver knows what to expect of the hardware so
that it can stay within the known working range of the hardware.

> <http://marc.info/?l=linux-wireless&m=125072768530674>
>
> There is only ONE chip, with custom "regdomain" values in the EEPROM.
> And the *driver* applies constraints based on that value. No more no less.
> Then, crda/wireless-regdb only can narrows things a bit more.

Exactly.

> Atheros chips can go beyond IEEE 802.11 frecuencies.

Of course, a wireless card is essentially a software controlled radio
transceiver with firmware designed to do IEEE 802.11. There is
precious little that would prevent anyone from making it do other
things, the Libertas chips used by the OLPC devices are an example, as
is a group of people who were modifying Prism cards to work as
stand-alone devices. Hardware can often be much more capable than what
it's used for, for example, a certain type of TV tuner card can be
turned into a quite powerful software defined radio, I have no reason
to believe that this couldn't be done with a wireless card.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
