Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39396 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1JLNKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 09:10:07 -0400
Received: by wyg34 with SMTP id 34so655180wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 06:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
References: <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
	<20110927214245.GA1416@ecki>
	<CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
	<CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
	<CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
	<CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
	<20111003084823.GA1521@ecki.lan>
	<CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
	<20111004181534.GA1502@ecki>
	<CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
	<CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
Date: Wed, 12 Oct 2011 18:40:06 +0530
Message-ID: <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com> (sfid-20111012_151012_455858_D4D8275D)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>,
	Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clemens,

please try this in case it helps anything
to debug the issue.

 this should avoid dead beef and the interrupt when we access MAC
registers when the MAC is asleep. also i did not see MAC irq being not
triggerred in your case(AR_INTR_ASYNC_CAUSE should be 0x2) or may be
its not an interrupt triggered by the chip itself. thanks

diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index 93fbe6f..51b7c54 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -770,6 +770,7 @@ irqreturn_t ath_isr(int irq, void *dev)
        enum ath9k_int status;
        bool sched = false;

+       ath9k_ps_wakeup(sc);
        /*
         * The hardware is not ready/present, don't
         * touch anything. Note this can happen early


On Wed, Oct 5, 2011 at 6:32 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 5 October 2011 14:28, Clemens Buchacher <drizzd@aon.at> wrote:
>> For the record, instead of going to full sleep, I can reproduce the
>> issue with
>>
>>  echo devices >/sys/power/pm_test
>>  echo mem >/sys/power/state
>>
>> but not with
>>
>>  echo freezer >/sys/power/pm_test
>>  echo mem >/sys/power/state
>>
>> So it could still be a different device that's causing the issue? I
>> can try unloading all kinds of modules. Or is there an option to
>> suspend just one device?
>
> Right. So its likely something (more) odd. Yes, see if that's the case
> :) At this point I'm going to punt this to the power management/ACPI
> people .:)
>
> Good luck!
>
>
> Adrian
>



-- 
shafi
