Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:37600 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZGMRhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 13:37:08 -0400
Received: by qyk30 with SMTP id 30so827479qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 10:37:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A5B301B.8060405@gmail.com>
References: <4A5B301B.8060405@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Jul 2009 10:36:47 -0700
Message-ID: <43e72e890907131036y4d12f532ta7a303577bcb4014@mail.gmail.com>
Subject: Re: Proper Regulatory Enforcement
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 13, 2009 at 6:01 AM, Richard Farina<sidhayn@gmail.com> wrote:
> Many discussions in #Linux-wireless and even on this list seem to revolve
> around how regulatory enforcement is provided.  At one point I thought that
> I understood how this works, but as things evolve it seems I am losing my
> edge.  With the goal of understanding a unified policy for all drivers and
> proper (safe) regulatory enforcement, I'm starting this thread so that
> people can help clarify how this currently works, and how it should work.
>
> As I see this all working in an ideal world is as follows:
>
> 1.) Driver reads eeprom of card for the permissible frequencies for that
> hardware. It is only safe to allow the frequencies in the eeprom because we
> cannot assume that any other values were calibrated in the hardware.  This
> information (or initial regulatory domain) should be passed up to and
> immediately enforced by crda.  Drivers shouldn't have their own enforcement
> in addition to crda as we have a properly functioning regulatory enforcement
> engine and having 1 per driver makes things pointlessly complicated.

You for got the case 0) where cards have no EEPROM information from
which a regulatory_hint() can be constructed for. In this case we
always world roam at first but user input can then set the channels
for the user. User input in these cases may enable new channels as the
card has no location information. It certainly would shave off some
more pounds from the driver.

You also forgot the case where cards have EEPROM information but also
have a few set of custom world regulatory domains. For example,
Atheros cards have 12 world regulatory domains, apart from the group
regulatory domains (which map to an alpha2) or a specific alpha2
country code mapping. cfg80211 allows drivers to specify custom world
regulatory domains and use them when applicable. It may be the case we
can just get rid of these in favor of the 1 world regulatory domain
that cfg80211 has, but that needs some good internal company review.

> 2.) If the user sets a reg domain, intersect user reg domain with eeprom reg
> domain.
>
> 3.) When user connects to AP, if available, read country IE and intersect
> that with the currently effective reg domain (which is at least the eeprom
> and may include user input from step 2 as well).

You also forgot about the world roaming feature of scanning and
finding beacons. When you scan and find a beacon from an AP passive
scan flags and no-ibss flags are lifted. This is under the assumption
APs which beacon can be trusted. This feature is only used when your
card is world roaming.

> I realize some distros have cool stuff happening like setting a reg domain
> using the location from the timezone or some other cool thing.  For the
> purpose of this discussion however, that is really nothing different from a
> user set reg domain (in fact I believe that is how it is done) so let's not
> worry about those specifics of "well the user didn't directly call iw reg
> set so blah blah blah".
>
> How far off base am I here?

Pretty good -- except for the few notes above.

> I know that Intel enforces reg domain in their
> ucode and we cannot do anything about it,

Well you can help compliance further by setting the regdomain, that
may disable channels your country does not allow for which the intel
cards may have passive scanning enabled for. This can help in scan
time since no APs are expected to be found in those channels.

> but I'm more interested in the
> cards where our drivers have full control.  Are the drivers themselves
> performing limiting that users don't even get to see?

ath9k reads the CTL (Conformance Test Limit) indexes for the target
frequency and may reduce power further depending on the information
read. This is where that argument about calibration comes in -- this
the that calibrated data that should be cared for. Each frequency a
card is capable of gets tested and has a CTL index map. If it does not
have a CTL index power the max regulatory EIRP is used. CTL index for
Atheros cards come in quite handy at band edges where we want to
ensure the power curve does not go over the edge but it also can be
used for regular regulatory compliance and ensures you also won't bust
your card by trying to use a tx power that can damage the card.

> Or is all this
> actually passed up to crda as it should be?

CRDA is used to get the driver regulatory control information for each
country. Drivers then can use calibration data at will for further
compliance. Each device may do this differently. For instance, I have
no idea how Intel handles band edge power compliance parameters, it
must be data stuffed in the EEPROM somewhere or it may just user a
lower safe value.. not sure. Also not sure how Broadcom does this, I
think Johannes mentioned to me once that the firmware may be doing
that.

> I'm personally especially
> interested in how the three atheros drivers do it, but I think this
> discussion should extend beyond my personal interests and any and all
> drivers should be discussed.

Some devices may not even have such band edge calibration data, and
don't ask me how they ensure proper regulatory power is used, I know
only exactly how Atheros stuff does it.

  Luis
