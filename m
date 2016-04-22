Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60543 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbcDVSJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 14:09:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
References: <20160413060916.GA21184@localhost> <5521267.mr5HLCdTY6@wuerfel>
	<1460896953.15362.2.camel@sipsolutions.net>
	<4679823.7bDEQhE9qO@wuerfel>
	<1461056272.2766.8.camel@sipsolutions.net>
Date: Fri, 22 Apr 2016 21:09:11 +0300
In-Reply-To: <1461056272.2766.8.camel@sipsolutions.net> (Johannes Berg's
	message of "Tue, 19 Apr 2016 10:57:52 +0200")
Message-ID: <87inz9y0qg.fsf@purkki.adurom.net> (sfid-20160422_200941_796893_CCE88B8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2016-04-18 at 00:10 +0200, Arnd Bergmann wrote:
>> On Sunday 17 April 2016 14:42:33 Johannes Berg wrote:
>> > 
>> > I was thinking more restrictively of just the stuff that can't even
>> > be built without modifying the sources - like the "#if VERBOSE"
>> > thing.
>>
>> All the DEBUG() statements are inside of this kind of check, so if we
>> remove the #ifdefs, it would be logical to remove the rest of the
>> debugging infrastructure (DEBUG() macros, SHOW_*, pc_debug, maybe
>> more) as well.
>
> Seems reasonable.
>
> Maybe we should Cc the maintainer, but I suspect that since the driver
> is marked Obsolete anyway Luis won't care either :)

I'm planning to apply this patch anyway, the debugging infrastructure
removal can be a followup patch. But please let me know if I should drop
this instead.

-- 
Kalle Valo
