Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37791 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZBFVIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 16:08:16 -0500
Received: by fxm13 with SMTP id 13so1481857fxm.13
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 13:08:14 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: Remove TSF atomic requirement from the documentation
References: <20090205165834.63840@gmx.net> <87fxirpe1q.fsf@litku.valot.fi>
	<1233953047.4175.27.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 06 Feb 2009 23:08:12 +0200
In-Reply-To: <1233953047.4175.27.camel@johannes.local> (Johannes Berg's message of "Fri\, 06 Feb 2009 21\:44\:07 +0100")
Message-ID: <87ocxfp937.fsf@litku.valot.fi> (sfid-20090206_220820_423394_E9B5119C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-02-06 at 21:21 +0200, Kalle Valo wrote:
>> "Alina Friedrichsen" <x-alina@gmx.net> writes:
>> 
>> > The atomic requirement for the TSF callbacks is outdated. get_tsf() is
>> > only called by ieee80211_rx_bss_info() which is indirectly called by
>> > the work queue ieee80211_sta_work(). In the same context are called
>> > several other non-atomic functions, too. And the atomic requirement
>> > causes problems for drivers of USB wifi cards.
>> 
>> Atomicity requirement also creates problems for SPI based devices, not
>> only USB. So I strongly support for removing the requirement.
>> 
>> Unfortunately I don't have time to review this, though. Sorry.
>
> It's ok, I took a look, there's no such requirement (any more).

Oh good. Thanks for checking this.

Alina, it would be nice to explicitly mention that the function can
sleep. Otherwise driver authors need to guess if sleeping is allowed
or not.

-- 
Kalle Valo
