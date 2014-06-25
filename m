Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8567 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaFYR4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 13:56:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
	<20140623191504.GD1390@garbanzo.do-not-panic.com>
	<53A89011.1010806@candelatech.com>
	<87pphy7ta5.fsf@kamboji.qca.qualcomm.com>
	<20140625165247.GK1390@garbanzo.do-not-panic.com>
Date: Wed, 25 Jun 2014 20:56:07 +0300
In-Reply-To: <20140625165247.GK1390@garbanzo.do-not-panic.com> (Luis R.
	Rodriguez's message of "Wed, 25 Jun 2014 09:52:47 -0700")
Message-ID: <87pphw3mbs.fsf@kamboji.qca.qualcomm.com> (sfid-20140625_195619_474032_DE753A88)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> On Tue, Jun 24, 2014 at 08:47:46AM +0300, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>> 
>> > As for being confusing, the current code is nasty and it is very hard
>> > to have any idea why things do or do not work, especially if you do not
>> > have ability to add printk all over the place to figure out what the
>> > code is actually doing.
>> 
>> Heh, this is exatly what I do when I debug regulatory issues :)
>
> CFG80211_REG_DEBUG isn't too chatty already?

Unfortunately it's not enough. Sometimes I need to debug the regulatory
code line by line, it's just that difficult to understand. There are all
sort of odd checks everywhere in the code which affect behaviour.

>> > I think some more effort should go into printing out a lot more
>> > information about the regulator domain decisions, through printk
>> > or related call if nothing better is found...
>> 
>> IMHO the regulatory code is the most fragile part of Linux wireless
>> stack 
>
> Changing anything on regulatory can have an impact on many things but
> lets be clear of the difference on the nature of quality over impact due
> to the nature of what the code does and its impact. I invite you to
> compare the code quality on the existing regulatory infrastructure from
> what was in place on the atheros driver HAL for regulatory control. Now
> *that* was incomprensible and somehow we managed to evolve to something
> central and shared on Linux.

Sure. I haven't looked at HAL, but I'm sure what we have in cfg80211 is
better. But the way I'm seeing is that everyone are just submitting
random fixes for their issues and the code is getting more convuluted in
every release :/ And I also see that some of the functionality in
regulatory code seems to happen by accident, not by design. So I'm
getting very worried about this.

> Code needs to evolve though and I do agree we need to evolve things
> to a more mature foundation. More details on that regards below.
>
>> and needs a rewrite. It needs to be simple and easy to understand.
>
> There is actually quite a bit of documentation:
>
> http://wireless.kernel.org/en/developers/Regulatory
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules
> http://wireless.kernel.org/en/developers/Regulatory/CRDA
> http://wireless.kernel.org/en/developers/Regulatory/wireless-regdb
>
> I'm not familiar with smaller pieces of code on the kernel with as much
> documentation as this. The code actually also includes quite a bit of
> kdoc and comments. Small code changes however can have an impact though
> and as technologies advances we have more complex corner cases and
> the state machine of regulatory keeps evolving as such a more evolved
> infrastructure is indeed needed to help us cope and ensure we don't
> have regressions as we evolve the code.

I don't think documentation is the solution here. Documentation is
always behind the actual implementation and it doesn't really help to
fix bugs. The best is if the code is simple enough so that it documents
itself.

-- 
Kalle Valo
