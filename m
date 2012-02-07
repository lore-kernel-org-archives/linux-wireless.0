Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54867 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2BGVlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 16:41:09 -0500
Received: by wgbdt10 with SMTP id dt10so7755379wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 13:41:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120206071012.GA6534@vmraj-lnx.users.atheros.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com>
	<20120203055645.GA15811@vmraj-lnx.users.atheros.com>
	<CAJ-Vmo=AXrnPAbvbfSAco8xkUQWKFLGMWKEYHMq-FsxsmqBbFA@mail.gmail.com>
	<20120206071012.GA6534@vmraj-lnx.users.atheros.com>
Date: Tue, 7 Feb 2012 13:41:07 -0800
Message-ID: <CAJ-VmokAdqKMMsrHpuj1fo-Y7c96DCq2NbFGiRGMAsGaw6Na5w@mail.gmail.com> (sfid-20120207_224113_132146_BE58358F)
Subject: Re: [PATCH 2/2] ath9k_hw: improve ANI processing and rx desensitizing parameters
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 February 2012 23:10, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:

>> I'd like to suggest we hold off on committing anything that really
>> changes the ANI behaviour without figuring out exactly what's going on
>> underneath the hood. I think it's worthwhile filing a bugzilla report
>> and stuffing that patch against the bug though, so it's not "lost".
>>

[snip]

> To be very precise, there are two types of weak signal detection logic in our
> baseband -
>
> 1) normal weak signal detection logic - involves thresholds m1_thresh,
>   m2_thresh, m2_Count_thr
> 2) low weak signal detection logic - involves thresholds m1_thresh_low,
>   m2_thresh_low, m2_count_thr_low
>
> Type 2 is intended to handle low weak signals and internally baseband logic does
> averaging over larger time windows compared to type 1. In current ANI code,
> both types 1) and 2) are clubbed together and called as "weak signal detection".
>
> What we've found in extensive testing is that disabling type 1 and type 2 form of
> weak signal detection logic together causes "beacon miss". Disabling both types
> 1 and type 2 together is definitely harmful to our receiver as it cannot receive
> even medium strength signals. Disabling type 2 alone is completely safe which
> is what we're doing in this change.
>
> For disabling type 2 logic alone there is a register field named
> "use_self_corr_low". So instead of maxing out threshold values of 3-4 registers
> we simply set use_self_corr_low=0 saving register writes. Hepe this could
> clarify your question.

This does, yes. I'll run this by the baseband guys just to see which
chips this applies to and I'll get back to you.

How'd you determine that it was these weak signal detection
parameters? I've been thinking about writing an ANI (well, "baseband")
visualisation tool for FreeBSD that just watches the error rates and a
few other registers and plots things. That way we could watch how
effective ANI is being over time.

Thanks very much for chasing this up!


Adrian
