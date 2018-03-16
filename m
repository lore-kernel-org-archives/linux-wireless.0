Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:47596 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751888AbeCPLig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:38:36 -0400
Subject: Re: [PATCH] wcn36xx: dequeue all pending indicator messages
To: Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, Ramon Fried <rfried@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20180315223725.28283-1-daniel@zonque.org>
 <3d6783ea-837c-a314-dea9-63906aeb0793@codeaurora.org>
 <e4dfbb05-10c7-2dc5-6995-ea34bd5945bc@zonque.org>
 <87y3is2ubq.fsf@kamboji.qca.qualcomm.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <f972e34a-7b56-5750-f86d-710cb046a8b1@zonque.org> (sfid-20180316_123840_155054_9607C033)
Date: Fri, 16 Mar 2018 12:38:34 +0100
MIME-Version: 1.0
In-Reply-To: <87y3is2ubq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 16, 2018 11:22 AM, Kalle Valo wrote:
> Daniel Mack <daniel@zonque.org> writes:
> 
>> Hi,
>>
>> On Friday, March 16, 2018 10:09 AM, Ramon Fried wrote:
>>> On 3/16/2018 12:37 AM, Daniel Mack wrote:
>>>> In case wcn36xx_smd_rsp_process() is called more than once before
>>>> hal_ind_work was dispatched, the messages will end up in hal_ind_queue,
>>>> but wcn36xx_ind_smd_work() will only look at the first message in that
>>>> list.
>>>>
>>>> Fix this by dequeing the messages from the list in a loop, and only stop
>>>> when it's empty.
>>> Interesting. does it solve a specific bug ? can you elaborate ?
>>
>> I'm poking around in the driver to hopefully find issues that cause
>> instability and failures in joining networks, which I am seeing a lot.
>> There are a number of bug reports regarding this, for instance
>>
>>   https://bugs.96boards.org/show_bug.cgi?id=538
>>   https://bugs.96boards.org/show_bug.cgi?id=319
>>
>> I'm following your patches and also started to look into the driver
>> myself, and during review, I noticed that list handling issue. I have a
>> big fat warning locally that would tell me if the list ever contains
>> more than one entry, but that never happens, as the indicator messages
>> are way too infrequent to trigger the race. So this isn't a real-world
>> issue as far as I can tell, but it is still quite obviously a bug. Hence
>> I considered posting a patch.
> 
> It's a good idea to mention in the commit log if the fix is for a
> theoretical issue and does not necessarily fix anything visible. Helps
> to understand the background, prioritise which release the fix should go
> etc.
> 

Well, it's a race which can (theoretically) happen anytime.
But sure, I will add another sentence to the commit log and resend.


Thanks,
Daniel
