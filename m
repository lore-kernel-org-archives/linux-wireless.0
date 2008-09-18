Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:49647 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbYIRSKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:10:40 -0400
Received: by mu-out-0910.google.com with SMTP id g7so18788muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:10:38 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:10:35 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181948.27507.IvDoorn@gmail.com> <200809181957.00151.mb@bu3sch.de>
In-Reply-To: <200809181957.00151.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182010.35285.IvDoorn@gmail.com> (sfid-20080918_201043_726976_50B8A00A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 19:48:27 Ivo van Doorn wrote:
> > Well no actually, when the radio state (software rfkill state in your words)
> 
> No, "radio state" is _not_ "software rfkill state" in my words.
> It's an independent state.
> The actual physical radio state is a combined state of the two sw and hw state bits.
> If either bit blocks the radio, it's physically blocked. We cannot toggle the hw bit
> from software.

Ah ok. In that case b43 should do:

send HW_BLOCK when the hardware rfkill state is set to block
send SOFT_BLOCK when the software rfkill state is set to block

But it shouldn't (and that change was the start of this discussion) send SOFT_BLOCK
when mac80211 disabled the radio.

> > it shouldn't be send to rfkill at all. rfkill should only be informed about the hardware
> > rfkill state changes.
> 
> So that's fine. We just revert the patch that caused all the trouble and we will
> gain _exactly_ that.
>
> > > Do not change any software state from within the hardware state change handler.
> > > This will blow up.
> > 
> > When you use userspace tools this won't happen since the hardware state change handler
> > will send an uevent to userspace which might act upon that, and will eventually send an
> > instruction back to the hardware, but that goes through a different thread.
> 
> It will semantically blow up. See the initial mail from Larry with the regression report.

Ok.

Ivo
