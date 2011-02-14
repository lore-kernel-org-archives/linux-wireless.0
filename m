Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:52342 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1BNX7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 18:59:39 -0500
Subject: Re: [PATCH] ssb: Make ssb_wait_bit multi-bit safe
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimjkFJrWpubECRRNybmvYdcAh3UUbMOa0iv166g@mail.gmail.com> (sfid-20110215_004511_709733_4814F921)
References: <1297725710.5683.17.camel@maggie>
	 <AANLkTimjkFJrWpubECRRNybmvYdcAh3UUbMOa0iv166g@mail.gmail.com>
	 (sfid-20110215_004511_709733_4814F921)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 00:59:29 +0100
Message-ID: <1297727969.5683.21.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 00:44 +0100, Rafał Miłecki wrote: 
> 2011/2/15 Michael Büsch <mb@bu3sch.de>:
> > ssb_wait_bit was designed for only one-bit bitmasks.
> > People start using it for multi-bit bitmasks. Make the "set" case
> > is safe for this. The "unset" case is already safe.
> 
> Thanks :)

This should not change the behavior of your patch, though,
as you only add an "unset" case, which was already correct.

So this doesn't fix an actual bug but rather hardens the code
for future use.

-- 
Greetings Michael.

