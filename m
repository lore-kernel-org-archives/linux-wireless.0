Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35449 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYIRSRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:17:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:17:12 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181957.00151.mb@bu3sch.de> <200809182010.35285.IvDoorn@gmail.com>
In-Reply-To: <200809182010.35285.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182017.12685.mb@bu3sch.de> (sfid-20080918_201742_601074_42A0B931)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 20:10:35 Ivo van Doorn wrote:
> On Thursday 18 September 2008, Michael Buesch wrote:
> > On Thursday 18 September 2008 19:48:27 Ivo van Doorn wrote:
> > > Well no actually, when the radio state (software rfkill state in your words)
> > 
> > No, "radio state" is _not_ "software rfkill state" in my words.
> > It's an independent state.
> > The actual physical radio state is a combined state of the two sw and hw state bits.
> > If either bit blocks the radio, it's physically blocked. We cannot toggle the hw bit
> > from software.
> 
> Ah ok. In that case b43 should do:
> 
> send HW_BLOCK when the hardware rfkill state is set to block
> send SOFT_BLOCK when the software rfkill state is set to block
> 
> But it shouldn't (and that change was the start of this discussion) send SOFT_BLOCK
> when mac80211 disabled the radio.

I'm kind of confused. You say one thing and revert it right in the next sentence.

-- 
Greetings Michael.
