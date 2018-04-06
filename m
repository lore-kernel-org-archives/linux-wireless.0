Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeDFJBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 05:01:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] rsi: remove unecessary PTR_ALIGN()s
References: <20180406083717.GA21857@mwanda> <5AC7338C.3000307@broadcom.com>
Date: Fri, 06 Apr 2018 12:01:40 +0300
In-Reply-To: <5AC7338C.3000307@broadcom.com> (Arend van Spriel's message of
        "Fri, 6 Apr 2018 10:45:00 +0200")
Message-ID: <87woxkd7yj.fsf@kamboji.qca.qualcomm.com> (sfid-20180406_110158_497409_B2073EDA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 4/6/2018 10:37 AM, Dan Carpenter wrote:
>> The issue here is that we allocate "data" and then set
>> "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer
>> instead of the original pointer.
>>
>> kmalloc() pointers are already ARCH_SLAB_MINALIGN aligned which is 8 or
>> more on everything except certain Xtensa variants.  We decided that if
>> the Xtensa people ever notice a bug here then we'll tell them the bug is
>> on their side.  ;)
>
> I am not sure if it was decided to be a xtensa bug, but just to ignore
> the issue until it would arise.

IIRC on other architectures the allocation is already aligned properly
so there shouldn't be any functional changes with this patch, expect on
xtensa of course.

> Anyway, not sure if the last sentence is useful in the commit message.

IMHO it is useful as it gives a summary of our discussion, just with a
humorous tone :)

-- 
Kalle Valo
