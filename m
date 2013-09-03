Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40323 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab3ICFIC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:08:02 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Joe Perches <joe@perches.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	<1377298929.2816.15.camel@joe-AO722>
	<87ioyjux5w.fsf@purkki.adurom.net>
	<1378144193.1953.88.camel@joe-AO722>
Date: Tue, 03 Sep 2013 08:08:00 +0300
In-Reply-To: <1378144193.1953.88.camel@joe-AO722> (Joe Perches's message of
	"Mon, 02 Sep 2013 10:49:53 -0700")
Message-ID: <87bo4av6fj.fsf@purkki.adurom.net> (sfid-20130903_070806_639471_C3666EB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Mon, 2013-09-02 at 17:15 +0300, Kalle Valo wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>> >> +#define wcn36xx_dbg(mask, fmt, arg...) do {			\
>> >> +	if (debug_mask & mask)					\
>> >> +		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
>> >> +} while (0)
>> >
>> > And maybe this one using pr_debug so dynamic_debug
>> > can work too.
>> 
>> Please, no dynamic_debug. It's useless on a wifi driver.
>
> Why is that?

It's not really usable in practise, at least the last time I looked at
it. It's cumbersome to enable log messages based on their line numbers
and line numbers change so you can't really make any scripts to help
with that. And enabling log messages on the file level is sometimes too
much. So it would really need some sort of grouping feature with a
stable interface.

-- 
Kalle Valo
