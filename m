Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48679 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2JIA6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 20:58:38 -0400
Date: Mon, 8 Oct 2012 18:00:03 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<johannes@sipsolutions.net>, <arend@broadcom.com>,
	<mjg59@srcf.ucam.org>
Subject: Re: [PATCH v2 3.7 1/2] cfg80211: fix antenna gain handling
Message-ID: <20121009010003.GN3354@lenteja.do-not-panic.com> (sfid-20121009_025842_409933_C16AC50D)
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
 <20121008183758.GJ3354@lenteja.do-not-panic.com>
 <50733D22.80407@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50733D22.80407@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 08, 2012 at 10:52:50PM +0200, Felix Fietkau wrote:
> On 2012-10-08 8:37 PM, Luis R. Rodriguez wrote:
> > On Sat, Oct 06, 2012 at 02:40:53PM +0200, Felix Fietkau wrote:
> >> No driver initializes chan->max_antenna_gain to something sensible, and
> >> the only place where it is being used right now is inside ath9k. This
> >> leads to ath9k potentially using less tx power than it can use.
> >> 
> >> Rather than going through every single driver, this patch initializes
> >> chan->orig_mag in wiphy_register(), ignoring whatever value the driver
> >> left in there. If a driver for some reason wishes to limit it independent
> >> from regulatory rulesets, it can do so internally.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  net/wireless/core.c |    3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >> 
> >> diff --git a/net/wireless/core.c b/net/wireless/core.c
> >> index 443d4d7..3f72530 100644
> >> --- a/net/wireless/core.c
> >> +++ b/net/wireless/core.c
> >> @@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
> >>  		for (i = 0; i < sband->n_channels; i++) {
> >>  			sband->channels[i].orig_flags =
> >>  				sband->channels[i].flags;
> >> -			sband->channels[i].orig_mag =
> >> -				sband->channels[i].max_antenna_gain;
> >> +			sband->channels[i].orig_mag = INT_MAX;
> > 
> > The commit log for a stable patch should describe the impact of not applying
> > it. In this case perhaps not being able to associate to APs due to unnecessary
> > power limitations -- but again that itself would only be true if some other
> > code used it in a way that it should not. I rather fix that if such cases
> > exist.
>
> I did mention that not applying this patch can in some circumstances
> lead to using lower tx power. I think it's obvious that this impairs
> performance/range.

It may be obvious to you not to the applier of the stable patch. You can
help by making it a bit more obvious to the reader what practical issues
users would run into without this patch.

> > Now the purpose of orig_mag is to allow drivers to spit out to kernel and
> > eventually userspace if we want it what it knows about the value of the
> > embedded antenna gain. The regulatory code for antenna gain is useful for us in
> > that it is the maximum allowed antenna gain values.
>
> If that was the purpose, then the implementation completely fails at
> treating it as such.

Indeed, we never really had a way to deal with this or a generic
interface or way for devices to expose this information to the OS.
Around March I had looked into ways in which we might be able
to create a standarized mechanism to enable any device to expose
its antenna gain to an OS. I only had poked a few folks but it
seems like if we wanted to we may be able to try to propose exposing
antenna gain via EFI. This would enable antenna gain to be exposed
on ARM, x86 givne that both archs will end up using it.

I never followed up but we should see if we can get this but I'll
use this as a prelude to work on this.

> Remember, that 'mag' stands for *maximum* antenna
> gain, not effective antenna gain or something. It is indeed treated as a
> regulatory maximum,

The antenna gain nomenclature came from the HAL but that's just baggage.  The
antenna gain stuff remained a puzzle for a central regulatory code base due to
the fact that as far as I am concerned only ath9k was exposing the antenna gain
value from EEPROM and using it. Other drivers would just use it as a max
regulatory value, but as you can imagine code typically always just keeps this
as a static value for all regulatory domains even though technically it is not,
this includes the HAL. A lot of this is due to the fact that you are not
supposed to be mucking with the antenna gain unless you are making APs and
if you are then that would need to be adjusted on the EEPROM anyway and
manufacturers have access to that. So in the end you're right but in
perspective its baggage and in the long term we should strive to generalize
an interface to expose the value to the OS if possible. In the meantime
I suspect your future work may help here get ahead of any other OS by
allowing us to treat dynamic antenna gains within the core of the kernel.
That is, perhaps we don't have a way to query the gain from an existing
card but at the very least the OS can enable us to report to the kernel
if a system integrator / engineer / researcher did modify the antenna gain
somehow to help adjust regulatory appropriately. So even if the old values
are not known at least the new values would be (with the CONFIG_ONUS option).

> and since only driver code uses the
> regulatory-capped maximum antenna gain, it does not make sense to allow
> the driver to set anything here initially.

Well its up to us to do what we want with it. I do wish we had a generic
interface to export antenna gains but we don't yet. Until then we can
only rely on the driver to do this.

> > This code itself hasn't been widely used throughout code but as you point out
> > ath9k does use it given that we can populate the antenna gain with what we read
> > from EEPROM and that in fact should *not* be reducing the max power from ath9k
> > but instead *helping* it in case it is smaller than the max allowed.
>
> I think you're confusing what the EEPROM says vs. what orig_mag really
> means. orig_mag means maximum allowable antenna gain at max. tx power
> that is still compliant.

Sure, but in the case of ath9k its also the programmed value on the EEPROM
and that is the antenna gain on the card.

> The eeprom value contains the antenna gain of
> the current system. These are two completely different things, and
> storing anything from the EEPROM in chan->max_antenna_gain makes no
> sense at all.

Its subjective really, but again, this is all baggage and what we *do*
should be to lay out the ground work to enable us to take this further.
As it is ath9k *does* set these value from the EEPROM and hence why
I considered it odd to set this a max value.

> > In retrospect there are a few things we can do here to improve this and use
> > this more efficiently. The orig_mag should be used by wiphy_register() as is.
> > Then upon wiphy_register() it calls wiphy_regulatory_register() and that
> > handles with anything regarding regulatory on the device. How about we change
> > this so that within wiphy_regulatory_register() (or regulatory change,
> > handle_channel()) we review if the device's antenna gain is over the regulatory
> > domain max allowed antenna gain and if it is we kick back simply mute the
> > device only allowing RX. If the device is changed to a regulatory domain that
> > allows for the antenna gain registered for the device then we unmute it. This
> > would in turn allow doing dynamic updates of the antenna gain as it seems you
> > want to introduce API for later, we'd end up checking for the newly supplied
> > antenna gain (and ensure that that value is higher than the embedded on on
> > EEPROM).
>
> Sorry, but that makes no sense to me, you're solving a nonexistant
> problem. The antenna gain value from EEPROM is already handled properly.

For all drivers? If so how?

> If the code detects that EEPROM antenna gain is n dBi over the
> regulatory antenna gain, it reduces tx power by n dBm. Muting the card
> in that case sounds weird and completely unnecessary to me.

Doesn't only ath9k do this?

In either case you are not disregarding the value set for custom
regulatory domains here.

How about just adding a check for now:

-       chan->max_antenna_gain = min(chan->orig_mag,
-               (int) MBI_TO_DBI(power_rule->max_antenna_gain));
+	if (chan->orig_mag)
+       	chan->max_antenna_gain =
+			min(chan->orig_mag, (int) MBI_TO_DBI(power_rule->max_antenna_gain));
+	else
+       	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
+

Then we can go ahead and clarify usage of these values.

  Luis
