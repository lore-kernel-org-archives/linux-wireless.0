Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753750AbdIDMrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 08:47:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
        <20170831075514.GA12340@redhat.com>
        <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
        <20170901085738.GA18397@redhat.com> <87y3pymqw2.fsf@purkki.adurom.net>
        <ac74a535-80f7-6211-62ca-1016302d24bd@lwfinger.net>
Date: Mon, 04 Sep 2017 15:47:30 +0300
In-Reply-To: <ac74a535-80f7-6211-62ca-1016302d24bd@lwfinger.net> (Larry
        Finger's message of "Fri, 1 Sep 2017 10:02:16 -0500")
Message-ID: <874lsipr4t.fsf@kamboji.qca.qualcomm.com> (sfid-20170904_144750_085590_A35639F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 09/01/2017 09:31 AM, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>>
>>> On Thu, Aug 31, 2017 at 10:33:28AM -0500, Larry Finger wrote:
>>>> Should the patch to wireless-drivers be annotated with a Stable reference so
>>>> that it is added to 4.12 and 4.13?
>>>
>>> According to Documentation/networking/netdev-FAQ.txt networking patches
>>> should not be marked cc:stable, instead a decent commit log should
>>> be written describing a bugfix. Which I believe it is done for
>>> this patch.
>>
>> But that's for net and net-next trees, not for wireless trees. With
>> wireless patches we use "Cc: stable@..." references.
>
> I see that this patch was just pushed for 4.14. I hope it got the
> Stable annotation at that time.

Justo to be sure, my understanding is that we are here talking about
this commit:

rt2800: fix TX_PIN_CFG setting for non MT7620 chips

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=83ec489193894e52bd395eec470f4f7c4286d4a5

I applied that already last Wednesday and that was without "Cc: stable".
So now someone should follow Option 2, wait the commit to hit Linus'
tree (I expect it to happen some time this week) and then send a note to
the stable team:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-2

Or if the commit doesn't apply cleanly to v4.13 then Option 3 is of
course the better approach.

-- 
Kalle Valo
