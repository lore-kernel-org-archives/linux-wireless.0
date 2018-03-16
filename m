Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbeCPKW4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:22:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: Ramon Fried <rfried@codeaurora.org>,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH] wcn36xx: dequeue all pending indicator messages
References: <20180315223725.28283-1-daniel@zonque.org>
        <3d6783ea-837c-a314-dea9-63906aeb0793@codeaurora.org>
        <e4dfbb05-10c7-2dc5-6995-ea34bd5945bc@zonque.org>
Date: Fri, 16 Mar 2018 12:22:49 +0200
In-Reply-To: <e4dfbb05-10c7-2dc5-6995-ea34bd5945bc@zonque.org> (Daniel Mack's
        message of "Fri, 16 Mar 2018 10:28:48 +0100")
Message-ID: <87y3is2ubq.fsf@kamboji.qca.qualcomm.com> (sfid-20180316_112300_176582_33624AF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> Hi,
>
> On Friday, March 16, 2018 10:09 AM, Ramon Fried wrote:
>> On 3/16/2018 12:37 AM, Daniel Mack wrote:
>>> In case wcn36xx_smd_rsp_process() is called more than once before
>>> hal_ind_work was dispatched, the messages will end up in hal_ind_queue,
>>> but wcn36xx_ind_smd_work() will only look at the first message in that
>>> list.
>>>
>>> Fix this by dequeing the messages from the list in a loop, and only stop
>>> when it's empty.
>> Interesting. does it solve a specific bug ? can you elaborate ?
>
> I'm poking around in the driver to hopefully find issues that cause
> instability and failures in joining networks, which I am seeing a lot.
> There are a number of bug reports regarding this, for instance
>
>   https://bugs.96boards.org/show_bug.cgi?id=538
>   https://bugs.96boards.org/show_bug.cgi?id=319
>
> I'm following your patches and also started to look into the driver
> myself, and during review, I noticed that list handling issue. I have a
> big fat warning locally that would tell me if the list ever contains
> more than one entry, but that never happens, as the indicator messages
> are way too infrequent to trigger the race. So this isn't a real-world
> issue as far as I can tell, but it is still quite obviously a bug. Hence
> I considered posting a patch.

It's a good idea to mention in the commit log if the fix is for a
theoretical issue and does not necessarily fix anything visible. Helps
to understand the background, prioritise which release the fix should go
etc.

-- 
Kalle Valo
