Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56036 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbYIRR5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:57:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:56:59 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181937.38257.mb@bu3sch.de> <200809181948.27507.IvDoorn@gmail.com>
In-Reply-To: <200809181948.27507.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181957.00151.mb@bu3sch.de> (sfid-20080918_195728_626378_A85FE3E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 19:48:27 Ivo van Doorn wrote:
> Well no actually, when the radio state (software rfkill state in your words)

No, "radio state" is _not_ "software rfkill state" in my words.
It's an independent state.
The actual physical radio state is a combined state of the two sw and hw state bits.
If either bit blocks the radio, it's physically blocked. We cannot toggle the hw bit
from software.

> it shouldn't be send to rfkill at all. rfkill should only be informed about the hardware
> rfkill state changes.

So that's fine. We just revert the patch that caused all the trouble and we will
gain _exactly_ that.

> > Do not change any software state from within the hardware state change handler.
> > This will blow up.
> 
> When you use userspace tools this won't happen since the hardware state change handler
> will send an uevent to userspace which might act upon that, and will eventually send an
> instruction back to the hardware, but that goes through a different thread.

It will semantically blow up. See the initial mail from Larry with the regression report.

-- 
Greetings Michael.
