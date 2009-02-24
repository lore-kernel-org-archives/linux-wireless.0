Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:33005 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZBXTCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 14:02:36 -0500
Received: by bwz5 with SMTP id 5so6064848bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 11:02:33 -0800 (PST)
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163738.20939.25890.stgit@tikku>
	<1235442058.4455.71.camel@johannes.local>
	<20090224090137.GB10851@jm.kir.nu> <87k57fy964.fsf@litku.valot.fi>
	<20090224184343.GA12620@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 21:02:24 +0200
In-Reply-To: <20090224184343.GA12620@jm.kir.nu> (Jouni Malinen's message of "Tue\, 24 Feb 2009 20\:43\:43 +0200")
Message-ID: <877i3fy7y7.fsf@litku.valot.fi> (sfid-20090224_200240_900452_C289B928)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Tue, Feb 24, 2009 at 08:36:03PM +0200, Kalle Valo wrote:
>> I see your point, I also have had to suffer because of buggy APs
>> having unstable TBTT. But the cost for this is high, currently it
>> increases two seconds the time to signal a lost connection to the user
>> space. I would hope to have something faster.
>
> How can that take two seconds?

I was just referring to the current implementation.

> All that would be needed here is to send out a unicast Probe Request
> to the current AP and wait for a Probe Response for a short timeout,
> say 20 ms. That shouldn't take more than 50 ms or so at most.. 

I agree. Or sending a null frame and waiting for ack is even faster,
but I think mac80211 doesn't yet have infrastructure to check the
acks. And not all hardware can support this, unfortunately.

> If the current implementation uses two seconds for this, there is
> certainly room for improvement there and I would rather see that
> done than lose this extra protection against buggy implementations
> (either AP or STA for that matter).

Sure. But the thing is that there are a lot of buggy APs which are
broken is so many different ways that I would like to have a limit for
workarounds we create. But I guess this workaround might still be
useful. I'll revisit this whenever I find time to work on roaming
improvements, hopefully after few weeks.

-- 
Kalle Valo
