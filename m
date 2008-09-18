Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15604 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYIRSX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:23:27 -0400
Received: by ey-out-2122.google.com with SMTP id 6so11731eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:23:25 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:23:21 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182010.35285.IvDoorn@gmail.com> <200809182017.12685.mb@bu3sch.de>
In-Reply-To: <200809182017.12685.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182023.21751.IvDoorn@gmail.com> (sfid-20080918_202346_972652_1E4C4125)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 20:10:35 Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Michael Buesch wrote:
> > > On Thursday 18 September 2008 19:48:27 Ivo van Doorn wrote:
> > > > Well no actually, when the radio state (software rfkill state in your words)
> > > 
> > > No, "radio state" is _not_ "software rfkill state" in my words.
> > > It's an independent state.
> > > The actual physical radio state is a combined state of the two sw and hw state bits.
> > > If either bit blocks the radio, it's physically blocked. We cannot toggle the hw bit
> > > from software.
> > 
> > Ah ok. In that case b43 should do:
> > 
> > send HW_BLOCK when the hardware rfkill state is set to block
> > send SOFT_BLOCK when the software rfkill state is set to block
> > 
> > But it shouldn't (and that change was the start of this discussion) send SOFT_BLOCK
> > when mac80211 disabled the radio.
> 
> I'm kind of confused. You say one thing and revert it right in the next sentence.

Ehm now you are confusing me.
You state that software rfkill state is not the state as requested by mac80211.

Since that is not the case b43 has 2 different methods to indicate the RFKILL state,
one is the hardware rfkill state and the second is the software rfkill state.
On top of that mac80211 sends configuration commands to b43 to set the radio state.

Configuration commands from mac80211 should _not_ trigger rfkill events since they
don't represent the RFKILL state but the RADIO state.

The RFKILL states as provided by the hardware do trigger rfkill state changes.

So apparently in b43 hardware you have 3 settings:
* radio enabled/disabled
* sw rfkill enabled/disabled
* hw rfkill enabled/disabled

The latter 2 provide RFKILL state changes when they are changed, but the first
one is the state as requested by mac80211 and thus should not generate events.

Ivo
