Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:37749 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbXFDWnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 18:43:10 -0400
Received: by py-out-1112.google.com with SMTP id a29so2571929pyi
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2007 15:43:09 -0700 (PDT)
Message-ID: <43e72e890706041543o493980dbwaa885739a2c8ec08@mail.gmail.com>
Date: Mon, 4 Jun 2007 18:43:09 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>,
	"Michael Wu" <flamingice@sourmilk.net>
Subject: Re: mac80211 regulatory domain confusion
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4661DCC7.7090907@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <4661DCC7.7090907@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/2/07, Daniel Drake <dsd@gentoo.org> wrote:
> One of the items preventing us moving zd1211rw to mac80211 is the lack
> of regulatory domain support in zd1211rw-mac80211.

Its debatable if this should be a blocker for new drivers going into
mainline. I don't think it should be. We are essentially providing
software and going the extra mile by implementing policy in places
where some vendors decided to get away with not doing it in hardware
due to economics. We do our best. If a vendor sales a USB gun and
there is a driver for it should the driver go into mainline (lets just
assume everyone wants one for their next birthday OK)? Absolutely.
Vendors and regulatory agencies should know better than relying on the
premise of security through obscurity for policy ;)

> In the softmac driver, we read the regulatory domain code out of the
> EEPROM, and look it up in a driver-supplied "allowed channels" table,
> and base future decisions from that.

This can be done now as well but it will all hopefully be replaced
eventually with something more centralized. I was hoping to have been
able to provide a more centralized replacement by now but it hasn't
been possible. The problem is we need a good complete regulatory agent
replacement. mac80211 provides some regulatory domain control but its
very minimal and the db for this should not be in-kernel but in
userspace. It will be a while before we are able to centralize all
this properly -- think cfg80211, some frequency broker for handling
interferences between all sorts of radio devices, and userspace
regulatory db.

> The current mac80211 port appears to allow all channels everywhere.
>
> I've seen the patch titled "d80211: Allow drivers to configure default
> regulatory domain". This is a confusing - if the driver sets the
> IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, then
> ieee80211_init_client is not called?

This does not seem right -- IIRC the idea was that if the driver can
read an eeprom value for a default regulatory domain then the driver
would populate ieee80211_regdom accordingly. The routine
ieee80211_unmask_channel() is just a bit smart about regulatory
domains (handles scanning rules for FCC, and ranges for MKK and FCC).
Any temporary hacks for regulatory control can go there.

> If ieee80211_init_client is all about applying a default regulatory
> domain to some internal structures, perhaps it should be renamed. If
> it's about, say, initializing a wireless client device, perhaps the
> check for default regdomain logic should be moved into that function.

ACK -- this should simply be renamed.

> Even after reading the discussion following that patch, I'm confused as
> to what the driver should be doing and what the stack should be doing.
> The ZD1211 hardware is capable of communicating on all channels, but the
> software is what enforces the regdomain restrictions.

Populating ieee80211_regdom accordingly depending on the eeprom's
regulatory defuallt domain and updating the list of available
ieee80211_channel_range's we have (only FCC and MKK are there so far)
seems like a worthy temporary solution. A switch statement on
ieee80211_init_client() can be added for regdomain which points
channel_range to the right channel_range.

> James Ketrenos wrote:
> > "regdomains" are not static maps; they evolve over time as
> > governments change their regulations.  The channels and features
> > supported by hardware is static based on what the device was
> > certified for.
>
> So, this suggests that zd1211rw should be reading the EEPROM, looking up
> allowable channels, and formulating the ieee80211_hw_mode structures
> based on the results.

NACK -- I'd say leave the ieee80211_hw_mode on zd1211rw as is and help
advance ieee80211_init_client() and friends as a temporary solution
for now.

> If we do that, should we also be setting the
> IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag? From the description of
> the flag, it sounds like we should:
>
> /* Channels are already configured to the default regulatory domain
>   * specified in the device's EEPROM */
>
> We would then bypass various logic in ieee80211_unmask_channel(), but it
> seems to me that the logic there should be being applied regardless of
> whether the driver suggested a regdomain or not. That function is also
> confusing in that it refers to "the firmware" -- whose firmware?

The behavior of IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED needs to be
fixed IMO. We can nuke those firmware comments IMO.

  Luis
