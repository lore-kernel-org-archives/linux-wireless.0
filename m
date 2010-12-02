Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45437 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0LBM3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 07:29:51 -0500
Received: by iwn42 with SMTP id 42so900524iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 04:29:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202122147.GN12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
 <1291288031-3409-17-git-send-email-vasanth@atheros.com> <AANLkTi=Fb0HA1DbaRp21kOS3x4-s_Oh+UZok2jNK3-PG@mail.gmail.com>
 <20101202120925.GM12908@vasanth-laptop> <AANLkTimmHLG8PU=1AweKqcPnyF4=6q3QNmA2nVeV00fh@mail.gmail.com>
 <20101202122147.GN12908@vasanth-laptop>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Dec 2010 23:29:30 +1100
Message-ID: <AANLkTinJy1rgPrGzYggctjMf7qqtq9Zjz-ahj4CEyRgM@mail.gmail.com>
Subject: Re: [PATCH V2 16/27] ath9k_hw: Read and configure antenna diversity
 control for AR9485
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 23:21, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Thu, Dec 02, 2010 at 05:46:05PM +0530, Julian Calaby wrote:
>> On Thu, Dec 2, 2010 at 23:09, Vasanthakumar Thiagarajan
>> <vasanth@atheros.com> wrote:
>> > No, these are to separate things.
>>
>> Are you sure? you seem to be doing:
>>
>> if (!AR_SREV_9485(ah)) {
>>     // CODE
>> }
>>
>> if (AR_SREV_9485(ah)) {
>>     // MORE CODE
>> }
>>
>> which I'm certain can be simlified as:
>>
>> if (!AR_SREV_9485(ah)) {
>>     // CODE
>> } else {
>>     // MORE CODE
>> }
>>
>> unless you're telling me that the value of AR_SREV_9485(ah) can change
>> in the course of the first statement.
>
> I mean the register configuration. In one case, chain 1 and chain 2
> are irrelevant for AR9485. The second is antenna diversity is
> enabled only for AR9485. Putting them in if..else would be
> misleading, though is can be in if..else.

Ah, fair enough then.

I was just thinking that this would save a check, though I'm guessing
this is setup code so it's not that time sensitive.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
