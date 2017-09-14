Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42366 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdINIjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 04:39:25 -0400
Message-ID: <1505378361.31630.2.camel@sipsolutions.net> (sfid-20170914_103939_504791_7A9A2FE9)
Subject: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>, Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 10:39:21 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend, Jouni, all,

Avi and I just discussed another use case for the PORT_AUTHORIZED flag,
which is PMKSA caching.

Assume you have 4-way-HS offloaded, then if you send a PMKID in the new
connection (doesn't matter if it's roaming or not), the AP may chose to
use it and start the 4-way-HS, or it may not be able to and start the
802.1X handshake.

In the supplicant, if you are waiting for the 1X handshake, then in the
case the PMKSA gets used the supplicant would wait forever, and
eventually terminate the connection because the handshake isn't
successful.

Thus, *both* cases need to know about the PORT_AUTHORIZED flag.

I previously didn't apply the patch for the flag in CONNECT
notification, but nobody is using it in ROAM notification so far, so
that we still have a chance of revisiting this.

Throwing a potential EAPOL-over-nl80211 (*) into the mix complicates
the picture further. For example, in that case the OPER_STATE might not
be set to UP until the port is authorized. In the case of roaming, this
might - on first sight - lead to toggling DOWN/UP if a new 1X handshake
needs to be done and the PORT_AUTHORIZED flag doesn't come with the
ROAM event. However, I think this is actually wrong as it would
probably lose IPv6 address assignment etc. - so I think we don't want
to do this even if we do have EAPOL-over-nl80211 and don't need the
oper_state to be up in order to do the 1X handshake. Do you agree with
this assessment?

Assuming this assessment is correct, this opens up another possibility:
tracking the PORT_AUTHORIZED state with a separate event:

 * new connection case - no PMKSA (usage)
   - CONNECT event
     - [if !eapol-over-nl: toggle oper state up]
     - initialize 1X state machines/timeouts
   - 1X handshake
   - send PMK to device for 4-way-HS
   - AUTHORIZED event
     - [if eapol-over-nl: toggle oper state up]

 * new connection case - PMKSA usage
   - CONNECT event
     - [if !eapol-over-nl: toggle oper state up]
     - initialize 1X state machines/timeouts
   - AUTHORIZED event
     - stop 1X state machine/timeouts
     - [if eapol-over-nl: toggle oper state up]

 * roaming case - no PMKSA (usage)
   - ROAM event
     - [no touching oper state]
     - initialize 1X state machines/timeouts
   - 1X handshake
   - AUTHORIZED event
     - [no touching oper state]

 * roaming case - PMKSA usage
   - ROAM event
     - [no touching oper state]
     - initialize 1X state machines/timeouts
   - AUTHORIZED event
     - stop 1X state machine/timeouts
     - [no touching oper state]


Does this seem reasonable? If possible, I prefer this to just having
the attribute, because with the attribute the roaming case will be
difficult, the natural code flow in the driver would probably make it
end up looking like this:

 * roaming case - no PMKSA (usage)
   - ROAM event
     - [no touching
oper state]
     - initialize 1X state machines/timeouts
   - 1X
handshake
   - CONNECT event w/ PORT_AUTHORIZED
     - [no touching oper
state]

which seems awkward.

Any other thoughts?

johannes

(*) is anyone working on that? I'll throw it on my list if not.
