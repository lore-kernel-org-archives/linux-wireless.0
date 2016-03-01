Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbcCAAPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 19:15:37 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com>
	<wrfja8mjhy7q.fsf@redhat.com>
	<CAGRGNgWRZFpMiVOE5Ri=uOH-+PoHApGPMQRHk=ssx=+yFWvH-w@mail.gmail.com>
Date: Mon, 29 Feb 2016 19:15:35 -0500
In-Reply-To: <CAGRGNgWRZFpMiVOE5Ri=uOH-+PoHApGPMQRHk=ssx=+yFWvH-w@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 11:04:39 +1100")
Message-ID: <wrfjk2lngijc.fsf@redhat.com> (sfid-20160301_011540_906589_81BE6D5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jes,
>
> On Tue, Mar 1, 2016 at 10:51 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Julian Calaby <julian.calaby@gmail.com> writes:
>>> Hi Jes,
>>>
>>> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> rtl8723bu_init_bt() is effectively the function enabling RF, so name
>>>> it appropriately.
>>>
>>> Should this be merged into the patches that introduce these functions?
>>
>> Again, this would be rewriting history and simply cause me to fight a
>> pile of patch conflicts rebasing things, for no gain, and at the risk of
>> introducing new errors in the process.
>
> Totally agree, this is definitely something that would cause conflicts.
>
> IMHO, history is only important if multiple people have contributed to
> something or it's being developed in public - which, for Linux, I
> define as it being in a maintainer's repository.

Well I have to completely agree with you on that one. I have had
multiple test out my development repository while I was working on
this. I reordered some patches for an earlier submission to reduce the
patchset.

> This patch set looks like you've been playing around with a bunch of
> stuff, completed *bu support, then just thrown it all over the wall
> without "prettying" it up for review and submission. If I were
> developing this I'd have happily rewritten history even if all I did
> was reduce the number of patches by squashing later fixes into earlier
> patches.

Well again, prettying things up by merging a lot of patches together
reduces the maintainability and the debug option. Patches often sit
outside a maintainer's tree for a long time, and the sub-maintainer and
developer may have to go back and bisect his/her way to a bug that was
introduced in the middle.

Linux development is not only what happens in the official tree, it's
also how it got there.

> I can see a lot of scope for reducing the number of patches in this
> patch set, so if you'd like me to play around with that, just ask.

Unless you plan to test every single change you suggest against all the
supported USB parts, then I'd say thanks, but no thanks.

The whole point of git is to commit often, and keep the history.

Jes
