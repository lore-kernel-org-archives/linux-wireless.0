Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51598 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbdINTWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:22:47 -0400
Message-ID: <1505416964.31630.17.camel@sipsolutions.net> (sfid-20170914_212253_198432_74CAECB6)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 21:22:44 +0200
In-Reply-To: <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com> (sfid-20170914_210836_116060_CBC37968)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
         <1505414172.31630.13.camel@sipsolutions.net>
         <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
         (sfid-20170914_210836_116060_CBC37968)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Yep, but I seem to recall there was some vague language that said the
> AP would delete the PMKSA if the client disconnected.

Ok, not sure about that. But even if the AP does, we could try to send
it and it just can't use it :)

> operstates.txt states that for new connections, operstate should be 
> dormant until 802.1x is complete & successful.  So the !eapol-over-
> nl condition would violate that, no?

As I just wrote in my other email, I think I'm totally confused
regarding this, and the supplicant already does it correctly - and you
can ignore the whole "!eapol-over-nl" conditions, and just read it like
what I thought we could only do in the eapol-over-nl case.

No idea how I ended up with the idea that you could only send data
frames when the netdev was IF_OPER_UP - that doesn't seem to have any
basis in reality.

> > > >        - initialize 1X state machines/timeouts
> > > >      - 1X handshake
> > > >      - send PMK to device for 4-way-HS
> > > >      - AUTHORIZED event
> > > >        - [if eapol-over-nl: toggle oper state up]
> > > > 
> 
> Given your explanation above, should this be [if !eapol-over-nl ..?


> So I agree that OPERSTATE_UP should not change on a roam.  I think
> we're both in agreement here.

Great.

> My earlier point is that software roams need to have the exact same 
> behavior as well.  And my understanding is that when we try to 
> Fast-Transition (e.g. issue a CMD_ASSOCIATE), operstate is no longer
> UP.

I'm not sure - I don't know what the state machine in wpa_s goes
through here. Probably easier to test than try to reason about the
code...

> At the very least there's lots of confusion with what is supposed to 
> happen with operstate and when.  So if we can work out & document a 
> consistent behavior, I'm all for it.

:-)

johannes
