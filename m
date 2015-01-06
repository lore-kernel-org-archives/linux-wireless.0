Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34052 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbAFXdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 18:33:35 -0500
Received: by mail-ig0-f171.google.com with SMTP id z20so4994319igj.16
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 15:33:35 -0800 (PST)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com. [209.85.223.179])
        by mx.google.com with ESMTPSA id d1sm199650igr.20.2015.01.06.15.33.33
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 06 Jan 2015 15:33:33 -0800 (PST)
Received: by mail-ie0-f179.google.com with SMTP id rp18so780053iec.10
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 15:33:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AA7042.50207@broadcom.com>
References: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54A8DBF4.4050202@lwfinger.net>
	<CAKXHbyN6LH_pFw1uoLXRzgJv-NcjbTLJvMZXfwYXDwuk9QDszA@mail.gmail.com>
	<871tn933jc.fsf@kamboji.qca.qualcomm.com>
	<54AA7042.50207@broadcom.com>
Date: Wed, 7 Jan 2015 00:33:33 +0100
Message-ID: <CAKXHbyNBV6=DPF4n0onzhEqAuS-PqLS5pwZj_OitRuYMvgpjvw@mail.gmail.com> (sfid-20150107_003351_332745_40B49F4F)
Subject: Re: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Fabian Frederick <fabf@skynet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-05 12:06 GMT+01:00 Arend van Spriel <arend@broadcom.com>:
> On 01/05/15 11:49, Kalle Valo wrote:
>>
>> Rickard Strandqvist<rickard_strandqvist@spectrumdigital.se>  writes:
>>
>>> As I hope you can see I have made some changes regarding the
>>> subject-line. Thought it was an advantage to be able to see which file
>>> I actually removed something from. There seems to be a big focus on
>>> getting right on subject-line right in recent weeks.
>>>
>>> I wonder why there is a script that takes a file name, and respond
>>> with an appropriate subject line?
>
>
> Is there a script for this? Anyway, I would say driver name is enough.
> Enough about the subject line ;-) I would like to give some general remarks
> as you seem to touch a lot of kernel code. First off, I think it is good to
> remove unused stuff. However, I would like some more explanation on your
> methodology apart from "partially found by using a static code analysis
> program". So a cover-letter explaining that would have been nice (maybe
> still is). Things like Kconfig option can affect whether function are used
> or not so how did you cover that.
>
> Regards,
> Arend
>
>
>> I don't think you can really automate this as some drivers do this a bit
>> differently. You always need to manually check the commit log.
>>
>>> But ok, I change my script accordingly. Should I submit the patch again?
>>
>>
>> Yes, please resubmit.
>>
>

Hi Arend

Yes, a script that had been excellent, I think!
I have one as part of my git send-email script, until a week ago, it
was enough that I removed the "drivers/" and changed all "/" to ": "
I have now been expanded my sed pipe a lot (tell me if anyone is interested)
But now I've seen everything from uppercase and [DIR], etc.
So I can not understand how anyone should be able to get the right
name without a good help.

Sure i like to share how I use cppcheck, but is very hesitant to write
this with each patch mails I send though!

I run:
cppcheck --force --quiet --enable=all .

Or a specific file instead of .

This will include, among other things get a lot of error message such,
+4000 for the kernel.
(style) The function 'xxx' is never used

For these I made a script that searched through all the files after
the function name (cppcheck missed a few). And save the rest so I go
through them and possibly send patches.


Kind regards
Rickard Strandqvist
