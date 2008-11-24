Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34383 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYKXXBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 18:01:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 15:01:50 -0800
Date: Mon, 24 Nov 2008 15:01:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Richard Farina <sidhayn@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: please don't regress ath5k.h]
Message-ID: <20081124230148.GL6245@tesla> (sfid-20081125_000155_147906_35749CA9)
References: <492A14A7.4040808@gmail.com> <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org> <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com> <20081124182943.GA9790@jm.kir.nu> <492AF4EC.4060705@gmail.com> <43e72e890811241335j41515d9an701d76de011efdc8@mail.gmail.com> <492B28F5.5000708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <492B28F5.5000708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 02:21:41PM -0800, Richard Farina wrote:
> Considering the fact that multiple companies sell Atheros wireless cards
> that support 4.9GHz and even down to 4.4GHz I'm going to guess that the
> hardware is capable just fine.  If it provides poor performance in
> testing then so be it, but right now, it looks pretty clean on the
> spectrum analyzer from where I was sitting the day I did my testing.

IIRC the way some of these frequencies work with Ubiquity cards are to
use the hardware's actual center of freqs andand these are then actually
mapped internally to the radio's lower freqs. At least this is how I saw
it working with the cards I had tried a while back.

> >>  I'm sure there are places where it
> >> is legal to use 2192MHz and even if not, look at the driver, it has a max of
> >> 2732MHz set in the driver (for the .11b/g radio), clearly the person who
> >> wrote that agrees that drivers should support the hardware.
> >>
> >
> > Please send patches to the wireless regulatory database if such places
> > do exist and please provide documentation of such findings:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
> >
> > Once we have listed a country with these settings then it makes sense
> > to add it to the database and to the card's capabilities. Keep in mind
> > that the EEPROM will always be respected though (patches pending).
> >
> >
> This seems kind of silly, I was purposely avoiding updating crda because
> I'm sure that if I do 99% of the people that use these frequencies will
> be breaking the law.

CRDA should have what *is* allowed for each country. Your driver then
can use its EEPROM for proper settings for a country. A user can further
enhance compliance by choosing the country he/she is in. What gets into
the kernel is code to properly enable your device for what it is
designed to do. What you end up doing later on (sharks with lasers
on their head) is up to you.

> At your request, I will send my suggested change
> set to wireless-regdb.  I only know about the USA but I'm sure if I
> google hard enough I can expand it at a later time.

Thanks.

> >> Honestly if you want to argue the legality I purposely posted an RFC for
> >> that, this change (and this email thread) is to stop a regression that would
> >> cause the hardware to no longer be fully and properly supported.
> >>
> >
> > This part is certainly important, and is greatly appreciated.
> >
> >
> >> Yes, I can maintain my own personal patches to all of the drivers in the
> >> kernel (as a matter of fact I likely do) but this kind of thing belongs in
> >> the kernel,
> >>
> >
> > What belongs in the kernel is driver components to make your 802.11
> > work. The arguments used here are similar to that of disagreeing with
> > easily allowing mac80211 to allow APs to operate without proper power
> > save implementation.
> >
> >
> >> we are discussing hardware support, nothing more.
> >>
> >
> > Yes however the channels must be registered too and the EEPROM must be
> > respected. More work on that area is in the right direction.
> >
> >
> I never said anything about hacking around the eeprom, nor did I even
> mention allowing people to tx on the channels I am adding.  Frankly I'd
> like to see half of what I do remain out of kernel because of the
> obvious problem of abuse, the changes I have outlined so far belong in
> the kernel to allow the hardware to operate to it's full extent.

I beleive you are missing my point though. I recently reviewed ath9k
regulatory for example and initially I was going to register every
single 5MHz step on the radio as a possibly used frequency. This is not
right because of the point Jouni mentions and a few others:

  * Your active and passive scan will take a lot longer
  * Calibrated data is tuned and tested for each standard channel
    the device has been tested for, not every frequency hop the device
    is capable of.
  * If you have a custom solution you can customize the driver
  * Custom solutions sometimes require 1-1 mapping of an intended
    frequency to a virtual frequency. To know exactly what frequency
    you really are operating requires customizations and patches for
    these type of devices.

What we want to support is standard 802.11 operation for the stanard
user for the regulatory regions in the regulatory database. Experimenters
and people with licenses to operate in non standard frequencies can go
ahead and tweak the driver and support it as they see fit, specially if
the devices have been properly calibrated to do so.

> >> Limiting the
> >> driver to enforce some random regulatory domain is pointless and against
> >> kernel policy as reg domain enforcement is supposed to be handled by crda or
> >> oldreg.
> >>
> >
> > oldreg is just that -- old, and it will be removed. It was there to
> > help with the migration and to account for the fact distributions may
> > not have CRDA packaged yet. Drivers should register channels that make
> > sense to support for 802.11, not every single channel a radio is
> > capable of tuning into. If not you'd be seeing the channel list
> > growing for other drivers  as well.
> >
> >
> Exactly why does 4400MHz not make sense to use 802.11 on in your
> opinion?  NATO disagrees as they have adopted equipment such as this:
> http://www.belairnetworks.com/solutions/armed_forces.cfm

NATO is not a regulatory agency, the FCC and currently the rules to
follow for the US follow Part 15 rules, not what a NATO document tells
you. If you see information on Part 15 rules which indicate you cna use
4400 MHz then by all means do send a patch to the wireless-regdb and
document your finding.

  Luis
