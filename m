Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbcCQQaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 12:30:09 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-03-14
References: <87y49llatn.fsf@kamboji.qca.qualcomm.com>
	<20160314.121528.1217892668324346880.davem@davemloft.net>
	<87twk8kxdx.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 17 Mar 2016 12:30:08 -0400
In-Reply-To: <87twk8kxdx.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 15 Mar 2016 09:34:18 +0200")
Message-ID: <wrfjegb9nk33.fsf@redhat.com> (sfid-20160317_173013_794837_DD04B066)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> David Miller <davem@davemloft.net> writes:
>
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Mon, 14 Mar 2016 10:31:48 +0200
>>
>>> I know I'm late now that merge window was opened yesterday but here's
>>> one more set of patches I would like to get to 4.6 still. There isn't
>>> anything controversial so I hope this should be still safe to pull. The
>>> patches have been in linux-next since Friday and I haven't seen any
>>> reports about issues. But if you think it's too late just let me know
>>> and I'll resubmit these for 4.7.
>>> 
>>> The most notable part here of course is rtl8xxxu with over 100 patches.
>>> As the driver is new and under heavy development I think they are ok to
>>> take still. Otherwise there are mostly fixes with an exception of adding
>>> a new debugfs file to wl18xx.
>>> 
>>> Please let me know if you have any problems.
>>
>> Pulled, thanks.
>
> Great, thanks a lot.
>
>> I really like Jes's work and I wish you had integrated it several
>> months ago, instead of sloshing him needlessly through a non-stop
>> cycle of very nit-picky issues, just FYI.
>
> I also like his work and I'm sorry for being too nit-picky. I have tried
> to be extra careful with the patches I send to you, especially with new
> drivers, and I guess I have been too pedantic. I'll try to lower the bar
> to a more reasonable level.
>
> But I actually started to wonder what you actually mean and checked the
> dates of initial rtl8xxxu submission from patchwork:
>
> 2015-08-29 v1
> 2015-08-30 v2
> 2015-10-15 v3
> 2015-10-21 applied 26f1fad29ad9 to w-d-next for v4.4
>
> Two months is quite long for a good driver like this but IIRC the
> initial commit was pending wireless-drivers directory reorganisation,
> and that just took too long on my side.

With all the trying to break down the patches and reorganizing them into
smaller blocks (disentangling 8723bu and 8192eu) to be submitted
independently, I have now ended up with a tree that simply is
unmergeable. I have spent about three days trying to roll back merges
and pop off my devel changes to allow it to merge, and I give up.

As a result I have created a new branch off wireless-drivers-next and
cherry picked all my devel patches on top of this. The new branch is
rtl8xxxu-devel. The old branch rtl8xxxu-nextgen I am going to let go
stale, but I will keep it in place as it contains all the old devel
history for the original driver prior to the initial upstream submission
of rtl8xxxu.

For anyone following rtl8xxxu development and/or submitting patches,
please submit against the new branch from now on.

Thanks,
Jes
