Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41141 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZAVVjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 16:39:23 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Thu, 22 Jan 2009 22:39:29 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <200901221600.14130.chunkeey@web.de> <49789418.40606@gmail.com>
In-Reply-To: <49789418.40606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901222239.29656.chunkeey@web.de> (sfid-20090122_223929_882717_9D2E79FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 January 2009 16:43:20 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
> > +	if (unlikely(!priv->common.hw->workqueue)) {
> > +		/*
> > +		 * Huh? mac80211 isn't fully initialized yet?
> > +		 * Please check your system, something bad is going on.
> > +		 */
> > +		WARN_ON(1);
> 
> please do not add WARN_ON's unless you're actually interested in the
> stacktrace, In this case it's a usb completion, so in most cases the
> backtrace isn't very interesting, wouldn't a printk be enough?
> [i was hitting this when testing, and it took several seconds to 
> get all the data to the console]

Ahh, wait!

In fact we "should" call BUG_ON here, as mac80211 is not fully initialized at
this point and we might have accidently submitted a dataframe to the stack.
(Of course, this attempt by the device to send garbage to the stack is
caught by the common-code... so no oops here)

However, I wonder if the WARN_ON gets triggered under normal operation or not.
(Just in case, no it does not trigger with the ISL3887 chips)

Regards,
	Chr
