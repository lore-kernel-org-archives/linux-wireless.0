Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65206 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZDWSCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:02:38 -0400
Received: by fxm2 with SMTP id 2so691042fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 11:02:36 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wl12xx: third submission
References: <87ab67b9y2.fsf@litku.valot.fi>
	<1240507929.30082.258.camel@johannes.local>
	<874owf8dls.fsf@litku.valot.fi>
	<1240509453.30082.265.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 21:02:35 +0300
In-Reply-To: <1240509453.30082.265.camel@johannes.local> (Johannes Berg's message of "Thu\, 23 Apr 2009 19\:57\:33 +0200")
Message-ID: <87zle76yf8.fsf@litku.valot.fi> (sfid-20090423_200241_958253_D33F431D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-23 at 20:49 +0300, Kalle Valo wrote:
>
>> No problem, I can update wl12xx as soon as you finalise the interface.
>> Just let me know.
>
> Well, I just posted it earlier as [PATCH] :)

Thanks, I'll start working on it tomorrow.

>> > how about IPv4 alignment? Could you read the packet header first,
>> > memmove that and then read the rest, i.e. do two wl12xx_spi_mem_read
>> > calls? Might or might not be more efficient...
>> 
>> SPI access add latency, it would be faster to read as much as possible
>> in one transaction.
>
> Question is how it measures against the CPU doing memmove() on the
> entire frame when necessary.

I don't have any numbers, but for example omap2_mcspi is scheduling
processes etc. so I would say that memmove() is cheaper. Does anyone
have more knowledge about this?

>> Is there anything which in your opinion prevents inclusion to
>> wireless-testing?
>
> Give that you and Bob are working on it, I don't think so. Except the
> API issue, which means it won't compile when John merges my patch.

The compilation fix is easy to solve, I'll take care of it.

Thanks for your comments.

-- 
Kalle Valo
