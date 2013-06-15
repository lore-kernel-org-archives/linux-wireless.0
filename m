Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33257 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3FOTdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 15:33:09 -0400
Received: by mail-lb0-f170.google.com with SMTP id t13so1498672lbd.15
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 12:33:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130614173419.GB28497@tuxdriver.com>
References: <1371206567.8278.3.camel@jlt4.sipsolutions.net>
	<20130614173419.GB28497@tuxdriver.com>
Date: Sat, 15 Jun 2013 22:33:07 +0300
Message-ID: <CANUX_P3s7RZt0geVDZwpjYXg58bA4e_Se40zKmCo2ZZYjj9ubA@mail.gmail.com> (sfid-20130615_213320_410889_71D8A767)
Subject: Re: pull-request: iwlwifi-fixes 2013-06-14
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I have two more fixes that I think would be worthwhile for 3.10 but
>> admittedly the scenario is somewhat unlikely, so if you want to hold
>> them for 3.11 I can live with that. In that case, I can put them into my
>> -next tree, or you can pull this into -next (but if you don't pull
>> wireless.git first you'd get some more fixes you already have.)
>>
>> These two patches fix two issues with using rfkill randomly during
>> traffic, which would then cause our driver to stop working and not be
>> able to recover at all.
>>
>> johannes
>>
>>
>
> It isn't obvious to me that these need to be included in 3.10.  I can
> pull this into wireless-next once the current stuff in wireless makes
> it to davem's tree.
>
> If you decide that these really need to go, please provide some more
> information on how likely users are to hit the bugs, or how serious
> the effects of that would be.
>

John, it is really your call. I understand these concerns in -rc5.
For the first patch, I am not 100% sure that it fixes anything else
that a print. It is obvious to me that without this patch, you might
get an error in the log (I reproduced it a few times). I tend to say
that the print is harmless though.
The second patch fixes a real issue. The issue is hard to reproduce
though. You need to get in a case where the queues are full (sw queues
are stopped) and at that precise time, you need to free the Tx queues
(RFkill - because any other flow would flush the queues first I
think). If you got into that situation, then the queues would remain
stopped after you switch the RFkill button again. So yes... Unlikely.

I would still recommend distros (Stanislaw is CCed) to take both
patches since they are really safe and can avoid issues.

Now you have all the data :-)
