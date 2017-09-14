Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50830 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbdINSgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 14:36:16 -0400
Message-ID: <1505414172.31630.13.camel@sipsolutions.net> (sfid-20170914_203621_086873_30E7981E)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 20:36:12 +0200
In-Reply-To: <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com> (sfid-20170914_202722_323657_4FE49B68)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
         (sfid-20170914_202722_323657_4FE49B68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

I'd actually only Cc'ed you to see if you were actually working on
EAPOL-over-nl80211 :-)

> Curious, isn't sending a PMKID for a non-roaming case not strictly
> per spec?  Is this just to avoid running 802.1x?

I don't think so, what makes you? In -2016 9.4.2.25.5 for example, the
spec says:

    The PMKID Count and List fields are used only in the RSNE in the
    (Re)Association Request frame to an AP and in FT authentication
    sequence frames.

Why should it only be valid in roaming? You might turn off and on wifi
and still have a PMKSA.

> How does this mesh with operstates outlined in 
> Documentation/networking/operstates.txt?  Are you treating the
> 'roaming' case as 802.1x 'reauthentication'?

I think we have to, because otherwise DHCP/IPv6 could happen again
after roaming - we really can't set the oper state to dormant during
the roaming.

> > Assuming this assessment is correct, this opens up another
> > possibility:
> > tracking the PORT_AUTHORIZED state with a separate event:
> > 
> >   * new connection case - no PMKSA (usage)
> >     - CONNECT event
> >       - [if !eapol-over-nl: toggle oper state up]
> 
> Doesn't this go against operstates.txt, Section 4?

Why?

> Also, I must be dense, but why is the behavior different between 
> eapol-over-nl and not?

Because for EAPOL-over-data, we actually have to have IF_OPER_UP to be
able to TX/RX the EAPOL frames.

> >       - initialize 1X state machines/timeouts
> >     - 1X handshake
> >     - send PMK to device for 4-way-HS
> >     - AUTHORIZED event
> >       - [if eapol-over-nl: toggle oper state up]
> > 
> >   * new connection case - PMKSA usage
> >     - CONNECT event
> >       - [if !eapol-over-nl: toggle oper state up]
> >       - initialize 1X state machines/timeouts
> >     - AUTHORIZED event
> >       - stop 1X state machine/timeouts
> >       - [if eapol-over-nl: toggle oper state up]
> > 
> >   * roaming case - no PMKSA (usage)
> >     - ROAM event
> >       - [no touching oper state]
> 
> My understanding is that oper state goes back to dormant in case we 
> re-associate.  At least we needed to set it back to UP after a fast 
> transition?

Like I said above, I really don't think we should/can do this, I think
we'd lose at least IPv6 connectivity in the meantime?

johannes
