Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37513 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3CRWra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 18:47:30 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so3284793wib.6
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 15:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANMvdA-YEzYM5PCEC=6bwoiFFejLFYuLYPZHhJLctEUOGHBokA@mail.gmail.com>
References: <CANMvdA-YEzYM5PCEC=6bwoiFFejLFYuLYPZHhJLctEUOGHBokA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 19 Mar 2013 09:47:09 +1100
Message-ID: <CAGRGNgWyp47qYv4uHUVdJ+sVRnJxHgPc45meUqB7p4mdc3Xr6g@mail.gmail.com> (sfid-20130318_234735_427411_7A7C4326)
Subject: Re: IW channels list question
To: Francisco Cuesta <ndarkness@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Francisco,

On Mon, Mar 18, 2013 at 9:31 PM, Francisco Cuesta <ndarkness@gmail.com> wrote:
> Hello iw developers,
>
> I would like to ask a question related to the command iw list. The
> channels shown with this command where are they taken from? I mean,
> does iw call the drivers' API to see which frequencies it can provide?

iw calls the kernel's API (nl80211) to get a list of channels
available for the device specified.

> I ask this in that if I change the regulatory domain to Japan for
> instance, I cannot see the 4.9GHz channels with iw list, does it mean
> that the driver doesn't support such a channels or that I maybe have
> to modify iw list source in order to make them show up?

There is much more going on. Everything is working exactly as it should.

Most wireless cards contain a small EEPROM which, amongst other
things, specifies the calibration parameters and some regulatory
information for that specific card. A card sold in a particular
country is generally calibrated to work with the channels specified by
that country's laws, and no calibration is performed for any other
channels. The driver restricts the usage of that card so that it only
uses the channels specified in the laws it was calibrated against.

As each country has different laws relating to which channels are
usable, the kernel regulatory code takes every piece of information we
have, whether this is data from the card or specified by the user, and
calculates a set of channels which satisfies the laws of all the
countries we may be in, given the information at hand.

In your case, firstly, your card is probably calibrated for a country
that doesn't allow wifi on 4.9GHz channels, so when you tell the
kernel that you're in Japan it calculates a set of channels that is
allowed where the card is from, and is also allowed in Japan and uses
that. Secondly, if I recall correctly, cards which can use the 4.9GHz
channels are fairly rare, as they're only developed for the Japanese
market.

I hope that explains it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
