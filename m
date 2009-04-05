Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40350 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZDEKD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 06:03:59 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>, linville@tuxdriver.com
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904051129.38904.mb@bu3sch.de> <200904051136.15285.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 05 Apr 2009 13:03:54 +0300
In-Reply-To: <200904051136.15285.mb@bu3sch.de> (Michael Buesch's message of "Sun\, 5 Apr 2009 11\:36\:15 +0200")
Message-ID: <87fxgnifhx.fsf@litku.valot.fi> (sfid-20090405_120405_004267_D6B679F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Sunday 05 April 2009 11:29:38 Michael Buesch wrote:
>
>> I think this message should only show if
>> CONFIG_MAC80211_VERBOSE_DEBUG is set. It's kind of expected that we
>> lose a beacon once in a while, so we shouldn't print verbose
>> messages to the kernel log (even if they are KERN_DEBUG).
>> 
>> And besides that, I think one can easily remotely trigger this
>> message and flood the logs. So it should probably _also_ be
>> ratelimited.
>
> Something like this:

I agree, the message confuses the users and creates way too much
problems. Your patch is a good solution, the message is still useful
for the driver developers.

> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
