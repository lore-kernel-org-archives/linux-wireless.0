Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:9758 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZAVVpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 16:45:49 -0500
Received: by ug-out-1314.google.com with SMTP id 39so575933ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 13:45:47 -0800 (PST)
Message-ID: <4978E908.4060103@gmail.com> (sfid-20090122_224554_761516_79F63488)
Date: Thu, 22 Jan 2009 22:45:44 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901221600.14130.chunkeey@web.de> <49789418.40606@gmail.com> <200901222239.29656.chunkeey@web.de>
In-Reply-To: <200901222239.29656.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 22 January 2009 16:43:20 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
>>> +	if (unlikely(!priv->common.hw->workqueue)) {
>>> +		/*
>>> +		 * Huh? mac80211 isn't fully initialized yet?
>>> +		 * Please check your system, something bad is going on.
>>> +		 */
>>> +		WARN_ON(1);
>> please do not add WARN_ON's unless you're actually interested in the
>> stacktrace, In this case it's a usb completion, so in most cases the
>> backtrace isn't very interesting, wouldn't a printk be enough?
>> [i was hitting this when testing, and it took several seconds to 
>> get all the data to the console]
> 
> Ahh, wait!
> 
> In fact we "should" call BUG_ON here, as mac80211 is not fully initialized at
> this point and we might have accidently submitted a dataframe to the stack.
> (Of course, this attempt by the device to send garbage to the stack is
> caught by the common-code... so no oops here)

Wouldn't you then want to catch it _before_ p54_rx()?

> However, I wonder if the WARN_ON gets triggered under normal operation or not.
> (Just in case, no it does not trigger with the ISL3887 chips)

i have never seen it, after the initial 32 times.
As-is, it currently triggers on every init however...

artur
