Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41115 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbZHFUlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 16:41:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix hardware key index handling
Date: Thu, 6 Aug 2009 22:41:00 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	gregor kowski <gregor.kowski@gmail.com>
References: <200908061036.50631.mb@bu3sch.de> <4A7AE8E6.4050301@lwfinger.net>
In-Reply-To: <4A7AE8E6.4050301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908062241.00398.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 August 2009 16:29:58 Larry Finger wrote:
> Michael Buesch wrote:
> > This fixes the hardware encryption keys index and array size handling.
> > 
> > Thanks to Gregor Kowski for reporting this issue.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > This should probably go as a bugfix.
> > (Does this actually fix the PHY transmission errors? I don't see them anymore...
> > Note that you need to enable debugging to see them.)
> 
> I still see the PHY transmission errors.

Ah ok. I also have a new AP. Maybe that's why I'm not seeing it here. I'll try
later further away from the AP. That would show them again then...

> I had two of them and a "RX: 
> packet dropped" debug message within seconds of reloading b43 with
> this patch included.

Should be fine. This happens sometimes.
Connection and rekeying does work. (Rekeying might still break if there's
heavy traffic. But that bug always was there. I think it's related to mac80211's
key handling. I also saw it on intel wireless.)

-- 
Greetings, Michael.
