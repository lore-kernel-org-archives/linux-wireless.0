Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:34895 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbFATmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 15:42:50 -0400
Received: by yhda23 with SMTP id a23so36145118yhd.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 12:42:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmmm6NA2Lb5TB9rSiXYWWarGLGaE5KFJW0_aaqz1YwR3g@mail.gmail.com>
References: <CAOiWkA_i8mSx_DtW-Z8mdSiqMZcUXJp0nwCrZGkEZDWBUb3cVg@mail.gmail.com>
	<CA+BoTQnfXGLSvbx+hLfi_2w90-LgC3Uba0ZcO+Pt7J3FcEE9wg@mail.gmail.com>
	<87vbf7vr3j.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmmm6NA2Lb5TB9rSiXYWWarGLGaE5KFJW0_aaqz1YwR3g@mail.gmail.com>
Date: Mon, 1 Jun 2015 15:42:49 -0400
Message-ID: <CAOiWkA8GepFEd2+47g_SfFFk5GuMOGCLkwwyZhj9MxchFgXxbA@mail.gmail.com> (sfid-20150601_214253_930037_9AEBA3A4)
Subject: Re: system hang with backports-20150511/20150525
From: Marty Faltesek <mfaltesek@google.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Martin Faltesek <martin.faltesek@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I disabled IEEE80211_HW_SUPPORT_FAST_XMIT before, and still saw the
hang. I repeated today to confirm.

I added the extra ath10k debug flags you requested, and it causes a
system reset without any messages, very soon after the last hbeat
timestamp. I've uploaded  log "crash.6.1.15.13.46" to
http://tinyurl.com/dmesg-ftrace.

Any advice on how to bisect when using backports?

On Mon, Jun 1, 2015 at 4:27 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 1 June 2015 at 09:13, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> +ath10k list
>>>
>>> On 1 June 2015 at 03:37, Marty Faltesek <mfaltesek@google.com> wrote:
>>>> Starting with backports-20150511, and continuing with
>>>> backports-20150525, we see frequent system hangs. backports-20150424
>>>> had no issue.
>>>
>>> I don't see such binary releases on
>>> https://backports.wiki.kernel.org/index.php/Main_Page
>>> Hence I don't know what kernel you've backported the drivers from and
>>> I can't compare anything.
>>>
>>> Can you provide more details, please?
>>
>> I suspect it's from here:
>>
>> https://www.kernel.org/pub/linux/kernel/projects/backports/2015/05/25/
>>
>> The backports project pages are a bit confusing and that location is
>> hard to find.
>
> Oh, thanks!
>
> Hmm.. There was a ton of changes between 20150424 and 20150511. For
> one, ath10k started to use chanctx API and FAST_XMIT. But it's not a
> given these two are to blame.
>
> The latter can be easily disabled by removing
> IEEE80211_HW_SUPPORT_FAST_XMIT from ar->hw->flags in ath10k's mac.c.
> The former.. not so easy. I'd be awesome if you could do a git bisect.
> The commit ids are a3da0fb6(good) f17107c(bad) (you need linux-next
> git repo including its tags for these ids to be resolvable).
>
>
> Michał
