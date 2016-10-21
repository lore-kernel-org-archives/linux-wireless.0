Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7661 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935246AbcJUTGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 15:06:05 -0400
From: "Zaborowski, Andrew" <andrew.zaborowski@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
Date: Fri, 21 Oct 2016 19:03:59 +0000
Message-ID: <F1E72F916E15444E976109681700BEE23F6AF7D9@IRSMSX102.ger.corp.intel.com> (sfid-20161021_210608_677461_9357A2C2)
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
         (sfid-20161021_024924_244249_6C67A54C),<1477038639.4068.28.camel@sipsolutions.net>
In-Reply-To: <1477038639.4068.28.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The problem is that you really want this to be offloaded to the device,
> *especially* if you care about low power usage, because you absolutely
> don't want to be processing each beacon (which is typically what we
> derive the data from today) in the host CPU - you want those to be
> filtered by the device so you don't wake up the host CPU every ~102ms.

Right, that would be a separate optimisation but it probably won't arrive
until there's an API that the drivers can implement, so I think this is a
prerequisite.

> Without offloading to the device, your patch is actually fairly much
> pointless, because you've already woken up the host CPU, at which point
> punting to userspace probably isn't all that much more expensive over
> the cost of waking up the CPU in the first place.

The userspace switches count too and are the main motivation for this
patch.  Eventually, as you say, things will depend on specific drivers
and you will want to optimise whatever you can assuming the hardware
you're constrained to.

> Looking at the code, it seems like only a single driver could support
> this in a pseudo-offloaded fashion (iwlmvm), where all the others that
> offload it today would not be able to support this API at all, unless
> they fall back to complete software processing which, as I wrote above,
> will have far worse power consumption consequences.
>
> Therefore, adding this API just for mac80211 seems pretty pointless,
> especially since you're targeting this for IoT, where I expect people
> will be using full-MAC chips rather than soft-MAC, with the consequence
> of not even using mac80211-based drivers. Oops.

Hence this mail, I want to find out what would be a good API and it
should work with both mac80211 and full MAC chips.  I included a mac80211
implementation because, well, it's in software and thus you can see it
and use it for reference, and it covers a range of hardware.

It seems like any mechanism you choose can be implemented on top of
hardware that supports a low and a high threshold by setting the next
values while handling the event related to the previous threshold crossing
event.  If the thresholds are specified by a middle value and a hysteresis
or distance, that would work equally well.
The API I added in the patch also allows offloading to such hardware.

The remaining drivers might not be able to support any useful mechanism.

>> The assumption is that you can't simulate the same behavior with just
>> the current NL80211_ATTR_CQM_RSSI_THOLD attribute.
>
> Is that true? Technically, it seems that perhaps if you wanted to have
> a few ranges, you could always pick one that's currently active, and
> program that into the driver/device, with a hysteresis big enough to
> extend to the edges of the next range, or something?

Yes, but not with the current netlink API since the cqm_last_rssi_event
(whatever the driver calls it) value is reset when you set new thresholds,
so you won't know what "last" value will be used, and you'll also get a
spurious event on the next beacon.

And then at least two drivers use the hysteresis value differently
(wl1251, cw1200).

In short a nl80211 change would be needed regardless of the mechanism
chosen.

Best regards

-----------------------------------------------------------
Intel Corporation Iberia, S.A. 
Registered Office: Torre Picasso, 25th Floor, 
Plaza Pablo Ruiz Picasso, no. 1, 28020  Madrid

Este mensaje se dirige exclusivamente a su destinatario y puede 
contener informacion privilegiada o confidencial. Si no es vd. 
el destinatario indicado, queda notificado de que la lectura, 
utilizacion, divulgacion y,o copia sin autorizacion esta prohibida 
en virtud de la legislacion vigente. Si ha recibido este mensaje por 
error, le rogamos que nos lo communique inmediatamente por 
esta misma via y proceda a su destruccion.

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
