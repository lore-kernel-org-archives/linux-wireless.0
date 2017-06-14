Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41480 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbdFNU2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 16:28:48 -0400
Message-ID: <1497472126.9377.12.camel@sipsolutions.net> (sfid-20170614_222852_641381_BF25D364)
Subject: Re: [PATCH V3 3/9] nl80211: add authorized flag to CONNECT event
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jun 2017 22:28:46 +0200
In-Reply-To: <6e0ab1a9-04c3-6840-bab2-119624087e21@broadcom.com> (sfid-20170614_111446_665588_B33FD2CC)
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
         <1497010130-16186-4-git-send-email-arend.vanspriel@broadcom.com>
         <1497344524.6068.5.camel@sipsolutions.net>
         <6e0ab1a9-04c3-6840-bab2-119624087e21@broadcom.com>
         (sfid-20170614_111446_665588_B33FD2CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > So I was going to apply this, but now I'm no longer sure.
> 
> Not sure if this means you can be convinced, but let me try anyway ;-)

:-)

> > First of all, I'm concerned it could confuse older tools that don't
> > expect to see the notification twice. OTOH, they'd get the
> > connected
> > notification now and not really know whether or not data can be
> > passed,
> > so it seems unlikely they'd rely on it - but are we really sure
> > about
> > that?
> 
> Not sure what should be considered under the term "older tools". For 
> what it is worth, in wpa_supplicant both nl80211 CONNECT and ROAMED 
> event result in wpa_supplicant ASSOC event handled in 
> wpa_supplicant/events.c. This event already deals with authorized
> flag  to support QCA vendor stuff which typed it as u8 attribute iso
> flag.

Yeah, I guess wpa_s would deal with it just fine. I'm a little
concerned there might be other tools, and we'd only find out in a long
time when all of this comes together for enough users.

OTOH, most tools that aren't already quite broken will hopefully use
wpa_supplicant events.

> > But it seems that wpa_s moves all state machines to COMPLETE when
> > it sends the PMK to the device for offload, so it won't really care
> > about when that finished?
> > 
> > However, I think this might actually be a BAD thing, because it
> > would leave higher layers trying to do DHCP when the link isn't
> > actually ready yet.
> 
> Indeed. It introduces a window where the link is not ready. When I 
> stumbled on that in wpa_s it made sense to me to have the second 
> notification.

Right.

> > (This, btw, is another problem we can solve with the EAPOL-over-
> > nl80211 since then we can set the carrier later when the port is
> > authorized.)
> 
> Agree. I did see that thread. However I kinda missed the whole 
> EAPOL-over-nl80211 idea. Was that result of summit discussion?

Yeah it came up a few times and we finally decided it's worth doing,
but so far nobody had stepped up yet. Looks like Denis decided it might
be worth doing.

> > So - I have no objections to this patch, but I think the double
> > notification needs to be revised, and if needed a separate
> > notification for "4-way-HS is done now" can be added.
> 
> The separate notification was suggested, but as you guys already
> added a flag in the ROAMED event we decided to do the same for
> CONNECT event. If you still have concerns about the double CONNECT we
> can revisit that or leave it for now and deal with it through carrier
> state with EAPOL-over-nl80211.

For ROAMED the case is clearer: it can either happen with or without
the attribute, but it'll never happen twice because of the attribute.
Also, if the attribute is ignored by some tool, it's pretty harmless
since it'll still know that it was roaming, it just won't know that no
EAP authentication is needed.

I think I'd be OK with adding a new notification, but EAPOL-over-
nl80211 seems like it'd solve this, and then we don't need the extra
notification since we can just set the carrier after it's all
complete... I don't really know. If we can wait a bit for this, I think
it'd be the nicer thing, and it looks like the currently existing code
has the race and is still working OK for people.

johannes
