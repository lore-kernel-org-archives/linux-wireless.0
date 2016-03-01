Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33586 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbcCAAc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 19:32:57 -0500
Received: by mail-io0-f193.google.com with SMTP id g203so15200410iof.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 16:32:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjk2lngijc.fsf@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
 <1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
 <CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com>
 <wrfja8mjhy7q.fsf@redhat.com> <CAGRGNgWRZFpMiVOE5Ri=uOH-+PoHApGPMQRHk=ssx=+yFWvH-w@mail.gmail.com>
 <wrfjk2lngijc.fsf@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 11:32:36 +1100
Message-ID: <CAGRGNgXgp4__T+Nj_yrV8JtbQz88CRr90BJkUKu-=HxZX1dCOA@mail.gmail.com> (sfid-20160301_013301_590435_8BCD2A29)
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 11:15 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>> Hi Jes,
>>
>> On Tue, Mar 1, 2016 at 10:51 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>>> Julian Calaby <julian.calaby@gmail.com> writes:
>>>> Hi Jes,
>>>>
>>>> On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
>>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>>
>>>>> rtl8723bu_init_bt() is effectively the function enabling RF, so name
>>>>> it appropriately.
>>>>
>>>> Should this be merged into the patches that introduce these functions?
>>>
>>> Again, this would be rewriting history and simply cause me to fight a
>>> pile of patch conflicts rebasing things, for no gain, and at the risk of
>>> introducing new errors in the process.
>>
>> Totally agree, this is definitely something that would cause conflicts.
>>
>> IMHO, history is only important if multiple people have contributed to
>> something or it's being developed in public - which, for Linux, I
>> define as it being in a maintainer's repository.
>
> Well I have to completely agree with you on that one. I have had
> multiple test out my development repository while I was working on
> this. I reordered some patches for an earlier submission to reduce the
> patchset.
>
>> This patch set looks like you've been playing around with a bunch of
>> stuff, completed *bu support, then just thrown it all over the wall
>> without "prettying" it up for review and submission. If I were
>> developing this I'd have happily rewritten history even if all I did
>> was reduce the number of patches by squashing later fixes into earlier
>> patches.
>
> Well again, prettying things up by merging a lot of patches together
> reduces the maintainability and the debug option. Patches often sit
> outside a maintainer's tree for a long time, and the sub-maintainer and
> developer may have to go back and bisect his/her way to a bug that was
> introduced in the middle.

I'm not advocating turning this into a couple of huge patches, I'm
saying that two patches that introduce a new op and adjust code to use
it should either be one patch or patches n and n+1, not separated by
tens of unrelated patches; and I'm saying that there's no point
keeping the history that a particular message used to be much more
verbose.

> Linux development is not only what happens in the official tree, it's
> also how it got there.

I've seen tens of new drivers introduced and accepted into Linux in
the time I've been watching these mailing lists and they tend to fall
into one of three categories:
1. Vendor dumps a huge ten-thousand line patch adding the new driver
then is told to split it up for review. (E.g. most SCSI drivers)
2. Developer submits a new driver in 10-20 patches which logically
bring up the device and add features. (E.g. most new WiFi drivers and
practically all drivers on the ARM list I follow)
3. Developer submits basic support for a device then releases dribs
and drabs of patches to add features. (E.g. b43)

You're trying to do both 2 and 3 here.

>> I can see a lot of scope for reducing the number of patches in this
>> patch set, so if you'd like me to play around with that, just ask.
>
> Unless you plan to test every single change you suggest against all the
> supported USB parts, then I'd say thanks, but no thanks.

Fair point. Look, at least rip out the *eu specific stuff until it's
complete. It's ugly to write write a bunch of stuff to add support for
a chipset, never get there, then disable it in the last patch.

> The whole point of git is to commit often, and keep the history.

I agree that committing often is essential for modern development, but
I don't think keeping every last detail of the code's history is
worthwhile.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
