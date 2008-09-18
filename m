Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:27624 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYIRSCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:02:45 -0400
Received: by fk-out-0910.google.com with SMTP id 18so18985fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:02:42 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:02:39 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181942.29122.IvDoorn@gmail.com> <1221760169.9262.91.camel@johannes.berg>
In-Reply-To: <1221760169.9262.91.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809182002.39497.IvDoorn@gmail.com> (sfid-20080918_200249_593955_7051D9A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Johannes Berg wrote:
> On Thu, 2008-09-18 at 19:42 +0200, Ivo van Doorn wrote:
> 
> > Well from my perspective:
> > Note that 'sw' is the RADIO state as requested by mac80211 and
> > 'hw' is the RFKILL state as indicated by the hardware
> > 
> > radio: block, rfkill: block => BLOCK
> > radio: block, rfkill: unblock => UNBLOCK
> > radio: unblock, rfkill: block => BLOCK
> > radio: unblock, rfkill: unblock => UNBLOCK
> 
> Can't that crap just live in rfkill?

Rfkill is intended to listen for RFKILL state changes and report
those to userspace. _Optionally_ it can handle it internally through
rfkill-input which will call toggle() to change the radio state.

It is not intended as the library through which all radio state changes
should go through. Because then we must change mac80211 to not
send the enable_radio command to the drivers, but should directly send
it to rfkill.

> rfkill_announce_softstate(OPEN/BLOCKED)
> rfkill_announce_hardstate(OPEN/BLOCKED)
> 
> and all the other junk happens there. And make sure this can be called
> from interrupts.

I think that limitation came from the notifier_block functions, but
Henrique knows more about those details.

Ivo
