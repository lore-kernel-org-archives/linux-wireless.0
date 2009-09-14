Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36568 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbZINMuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 08:50:22 -0400
Date: Mon, 14 Sep 2009 15:50:08 +0300
From: Jouni Malinen <j@w1.fi>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Artur Skawina <art.08.09@gmail.com>
Subject: Re: A station can't reconnect after it wakes up
Message-ID: <20090914125008.GA15494@jm.kir.nu>
References: <1248969930.29068.224.camel@sunlight> <4A7318E6.3000004@gmail.com> <1249312925.8515.187.camel@sunlight> <1252620184.26765.65.camel@sunlight> <1252767513.23427.26.camel@johannes.local> <1252799481.26765.145.camel@sunlight> <87my4z0w53.fsf@litku.valot.fi> <1252927472.26765.202.camel@sunlight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1252927472.26765.202.camel@sunlight>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 03:24:32PM +0400, Igor Perminov wrote:

> A step-by-step, which causes the issue, is:
> 1. A STA authenticates and associates with the AP and exchanges
> traffic.
> 2. The STA reports to the AP that it is going to PS state.
> 3. Some time later (but before max_inactivity) the STA device goes to
> the stand-by mode (not only its wi-fi card, but the device itself).

and drops the association state without sending disassociation frame..

> 4. The STA device wakes up and begins authentication with an
> Auth frame as it hasn't been authenticated/associated previously.
> 
> At the step 4 the AP "remembers" the STA and considers it is in the PS
> state, so the AP buffers frames, which it has to send to the STA.
> But the STA isn't actually in the PS state and so it doesn't check the
> TIM bits.

The authentication and association frames should work fine even in this
case since they should not be buffered.

> The only inconsistency of the STA implementation may be at the step 3 -
> it doesn't send a Disassoc frame before disconnecting.

Which it is free to do. Likewise, the STA would be free to send a data
nullfunc frame with PwrMgt field set to 0 immediately after association
to clear the PS state.

> Yes, mac80211 "remembers" STA's power save state.
> And my question is - what an event should trigger clearing PS state:
> A) An Auth/Assoc frame being received from the STA.
> B) An Auth/Assoc Resp frame being sent to the STA.
> C) A special API call from an application (hostapd).
> D) Something else, may be.

This is somewhat unclear.. Based on the current P802.11REVmb_D1.01, the
authentication or association frame exchange itself would not clear the
PS state at least as far as the use of PwrMgt field in the frame control
field is concerned. Furthermore, there is still discussion on how
exactly the authentication/association state changes in case of this
type of reassociation back to the same AP.

I think it would be a fair design to drop the power save buffered frames
and PS state information on disassociation or in general, when on the
AP, the STA State changes from 3 to 2 or 1. However, it is not clear
whether that happens in this particular case.

Taken into account that the AP can even change the Association ID for
the STA during reassociation, I would be fine with dropping the buffered
frames and clearing the PS state when association is completed
successfully (the STA ACKs the (Re)Association Response frame that had
status code 0). I would hope that the authentication frame sequence or
failed (re)association would not touch the PS buffer or state.

The real time when the association state changes in the AP is when the
ACK frame is received for (Re)Association Response frame. Of the options
you listed, this would be bit after (B), i.e., (C) might be needed to
get the exact timing right. However, I could probably live with (B),
too, in practice.

> But I think, we shouldn't call ap_sta_ps_end as is done for normal PS
> state switching, because that leads to sending buffered frames if any,
> which is undesirable in our case. Instead, we should simply purge of
> buffered frames and clear WLAN_STA_PS.

This is a very good point and we much indeed make sure we do not end up
sending the buffered frames out based on a new authentication or
association frame. This is especially important for the case when the
frames were buffered in RSNA, i.e., they were to be encrypted. During
association, there is no encryption keys available (well, apart from
802.11r FT protocol case when they are ready immediately after
association). However, if everything goes through fine, this may already
be protected by the IEEE 802.1X controlled port, i.e., the frames would
be dropped here if the new authentication has not been completed (but I
have not verified whether this is indeed the case in the current
implementation).

-- 
Jouni Malinen                                            PGP id EFC895FA
