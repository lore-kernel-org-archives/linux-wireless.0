Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56819 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1IPLe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:34:57 -0400
Received: by ywb5 with SMTP id 5so2823438ywb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 04:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E733236.6070803@broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<20110913174444.GG11772@tuxdriver.com>
	<CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
	<20110914084234.GA5550@kroah.com>
	<CACna6rxi6XTUfR_N-n5ss7hmouaaoyZnmvmtdM-pGEfvdaWmQg@mail.gmail.com>
	<400C43189542CE41BC0A5B252FC90136BC0CA8A32B@SJEXCHCCR02.corp.ad.broadcom.com>
	<CACna6ry51P=em3=tgEDvO4cUhTfG8T3NJdRkMD3iatdtrOCk7g@mail.gmail.com>
	<4E732F67.6030302@broadcom.com>
	<CACna6rxpbow2S3Ps+fFAzSNkN-b==dMsRur-o+WOz5dzUZZ+SQ@mail.gmail.com>
	<4E733236.6070803@broadcom.com>
Date: Fri, 16 Sep 2011 13:34:56 +0200
Message-ID: <CACna6rw_1U_Zpgux1v4Vg4-scezDb65K8BFO+tVOyGX0J5jQFw@mail.gmail.com> (sfid-20110916_133514_231662_E31BAA13)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Francis Moreau <francis.moro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 16 września 2011 13:25 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 09/16/2011 01:20 PM, Rafał Miłecki wrote:
>>
>> W dniu 16 września 2011 13:13 użytkownik Arend van Spriel
>> <arend@broadcom.com>  napisał:
>>>
>>> On 09/16/2011 12:55 PM, Rafał Miłecki wrote:
>>>>
>>>> 2011/9/16 Arend Van Spriel<arend@broadcom.com>:
>>>>>>
>>>>>> From: Rafał Miłecki [mailto:zajec5@gmail.com]
>>>>>> Sent: vrijdag 16 september 2011 12:43
>>>>>> To: Greg KH; linux-wireless@vger.kernel.org; Arend Van Spriel
>>>>>> Cc: John W. Linville; Francis Moreau
>>>>>> Subject: Re: About the patch: "staging: brcm80211: only enable
>>>>>> brcmsmac
>>>>>> if bcma is not set"
>>>>>>
>>>>>>
>>>>>> You're right, it wasn't a good idea.
>>>>>>
>>>>>> Arend: I've just sent patches to John giving you symbols needed by LCN
>>>>>> code. If there is something more missing, I didn't notice it yet, feel
>>>>>> free to report. AFAICS you should be able now to convert brcmsmac to
>>>>>> use bcma, if you wish to.
>>>>>>
>>>>>> --
>>>>>> Rafał
>>>>>
>>>>> Hi Rafał,
>>>>>
>>>>> The last time I refreshed my local wireless-testing repo was a while
>>>>> ago
>>>>> since kernel.org misery. Last commit being:
>>>>>
>>>>> commit b197329717cf054f4dbd8bd86196401bef738978
>>>>> Merge: a7c053d 93ee7a9
>>>>> Author: John W. Linville<linville@tuxdriver.com>
>>>>> Date:   Mon Aug 15 14:01:50 2011 -0700
>>>>>
>>>>>    Merge branch 'master' of
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/torva
>>>>>
>>>>>    Conflicts:
>>>>>        drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
>>>>>
>>>>> Could you indicate what patches I am missing. If you can provide those
>>>>> to
>>>>> me that would be awesome. For BCMA this is the latest I have:
>>>>
>>>> I've *just* sent my patches, they weren't applied yet. I was sure
>>>> you're subscribed to linux-wireless and you received them.
>>>>
>>>> Please take a look at:
>>>> [PATCH 1/6] bcma: cc: export more control functions
>>>> Message-Id:<1316169243-8808-1-git-send-email-zajec5@gmail.com>
>>>
>>> Ok,
>>>
>>> I saw that one. I was just trying to get the other bcma patches in a
>>> quickly
>>> manner, but I will start digging through 2 months of wireless patch
>>> emails
>>> :-(
>>
>> All the other patches were applied to wireless-next. Take a look at
>> git://git.infradead.org/users/linville/wireless-next.git
>
> Ah, noticed wireless-testing is also there. Missed the news about this
> (temporary) move to infradead.

OK. Still, it would be nicer to have you involved in brcmsmac's future
discussion, rather than just getting patches.

You spent *a lot* of time on cleaning brcm8021. You have to spend even
more. A very quick check gives:
> git log drivers/staging/brcm80211/brcmsmac/ | egrep '^commit' | wc -l
301
That doesn't include changes done before brcmsmac was created (when
brcmsmac was brcm80211).

Isn't it at least worth considering getting involved in b43?

-- 
Rafał
