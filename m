Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbcB2X6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:58:36 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 066/113] rtl8xxxu: Call device specific _config_channel()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-67-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgW+QS6dgYdvJgWQ+qKjLWHC-U1Ni7LAQUK0VXuJiQu2aA@mail.gmail.com>
	<wrfjio17hyco.fsf@redhat.com>
	<CAGRGNgU-Y05b1_G8pKctNEoBX3=nX+CFNi=djzO6iA6EesBUpA@mail.gmail.com>
Date: Mon, 29 Feb 2016 18:58:33 -0500
In-Reply-To: <CAGRGNgU-Y05b1_G8pKctNEoBX3=nX+CFNi=djzO6iA6EesBUpA@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 10:50:26 +1100")
Message-ID: <wrfjwppngjbq.fsf@redhat.com> (sfid-20160301_005839_530923_A2CF34F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jes,
>
> On Tue, Mar 1, 2016 at 10:48 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Julian Calaby <julian.calaby@gmail.com> writes:
>>> Hi Jes,
>>>
>>> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> Having a version for the newer chips without calling it doesn't do
>>>> much good.....
>>>>
>>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> Should this be squashed into the patch that introduces the new op?
>>
>> I can start rewriting history, but all that comes out of that is having
>> to fight patch conflicts rebasing things.
>>
>> If there was an actual functional reason for it, sure, but in this case
>> there isn't.
>
> Fair enough, it just looks odd to have fixes like this in a patch
> series that almost entirely consists of introducing new stuff.

As you can see from the dates, this code was written over time, one top
of adding already existing code.

Merging patches randomly into giant jumbo patches will make it
completely impossible to bisect and debug in case one of these changes
breaks something in the parts of the code that was working prior to
introducing this set.

So no, this is not at all odd, it's perfectly normal for this type of
code.

Jes
