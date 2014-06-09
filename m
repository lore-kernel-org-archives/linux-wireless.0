Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51237 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354AbaFIJRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 05:17:06 -0400
Message-ID: <1402305420.17674.0.camel@jlt4.sipsolutions.net> (sfid-20140609_111712_362540_29C178A4)
Subject: Re: [RFC option 2] mac80211: introduce refcount for
 queue_stop_reasons
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 09 Jun 2014 11:17:00 +0200
In-Reply-To: <1402298460.2004.34.camel@dubbel>
References: <1402068423-23359-1-git-send-email-luca@coelho.fi>
	 <1402080365-15462-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkX=ZpDc=R+nWxsrj026XyaaEiwrosaB2buRVif2aOnxQ@mail.gmail.com>
	 <1402298460.2004.34.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-09 at 10:21 +0300, Luca Coelho wrote:

> > I think you need to make sure all stop/wake calls are balanced
> > everywhere (including device drivers). Otherwise you risk breaking
> > things silently in some cases.

> Checking this might be tricky, actually, since I think there are some
> assumptions that stopping a queue that is already stopped is a NOP, but
> now we add to the refcount...

I don't think we can force drivers to keep track of this, we'll have to
keep the API without refcounting for drivers, I'd say.

johannes

