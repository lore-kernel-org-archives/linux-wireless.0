Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:39787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbYIRUJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:09:28 -0400
Received: by fg-out-1718.google.com with SMTP id 19so320817fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:09:26 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 22:09:22 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182023.21751.IvDoorn@gmail.com> <200809182034.00801.mb@bu3sch.de>
In-Reply-To: <200809182034.00801.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182209.22992.IvDoorn@gmail.com> (sfid-20080918_220949_356501_2C52F888)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 20:23:21 Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Michael Buesch wrote:
> > > On Thursday 18 September 2008 20:10:35 Ivo van Doorn wrote:
> > > > On Thursday 18 September 2008, Michael Buesch wrote:
> > > > > On Thursday 18 September 2008 19:48:27 Ivo van Doorn wrote:
> > > > > > Well no actually, when the radio state (software rfkill state in your words)
> > > > > 
> > > > > No, "radio state" is _not_ "software rfkill state" in my words.
> > > > > It's an independent state.
> > > > > The actual physical radio state is a combined state of the two sw and hw state bits.
> > > > > If either bit blocks the radio, it's physically blocked. We cannot toggle the hw bit
> > > > > from software.
> > > > 
> > > > Ah ok. In that case b43 should do:
> > > > 
> > > > send HW_BLOCK when the hardware rfkill state is set to block
> > > > send SOFT_BLOCK when the software rfkill state is set to block
> > > > 
> > > > But it shouldn't (and that change was the start of this discussion) send SOFT_BLOCK
> > > > when mac80211 disabled the radio.
> > > 
> > > I'm kind of confused. You say one thing and revert it right in the next sentence.
> > 
> > Ehm now you are confusing me.
> > You state that software rfkill state is not the state as requested by mac80211.
> 
> 
> Nono. I will try to explain it once again. It's really easy.
> 
> Think of b43 having two independent registers for rfkill. (the actual hardware
> is different, but that doesn't matter. It's a driver internal implementation detail).
> One of these registers is readonly and it does indicate the physical rfkill button state.
> If that register indicates BLOCK, we can't do anything about it. The radio is blocked.

Which qualifies for a HW_BLOCK signal

> However, we can still write to the second register and turn the radio off through
> that, too. We can also write to the second register to turn the radio on, _but_ it won't
> physically turn on until the physical button is pressed and the first register changes
> to Unblocked.

Since the hardware doesn't toggle this field when a key is pressed, it is more the state
of the radio as configured by mac80211. And thus shouldn't generate RFKILL events.

> So you say that rfkill should only be notified about changes in the first read-only
> hardware intication bit? If that's the case, it would be possible to turn the radio off
> through mac80211 calls (using the read-write register), but still have rfkill think it's
> unblocked.

Right. Because how I see the rfkill layer is that it doesn't represent the RADIO state
but the RFKILL state (and uses that to control the RADIO state).

Ivo
