Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:58239 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbYIRU0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:26:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so43379nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:25:58 -0700 (PDT)
Message-ID: <f488382f0809181325u1a02aa4dp85214c003df45336@mail.gmail.com> (sfid-20080918_222605_210924_832EAE85)
Date: Thu, 18 Sep 2008 13:25:58 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Ingo Molnar" <mingo@elte.hu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <dd18b0c30809181318o4d90126ycd30b9801776ef3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <f488382f0809181223n6131290w6c68171c236ac032@mail.gmail.com>
	 <dd18b0c30809181318o4d90126ycd30b9801776ef3d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 1:18 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Thu, Sep 18, 2008 at 12:23 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> On Thu, Sep 18, 2008 at 12:00 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>>> On Thu, Sep 18, 2008 at 11:42 AM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com> wrote:
>>>> On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
>>>>> irqpoll is a monster of evil and that should make your system crawl to
>>>>> its knees. I would advise instead we work with you fixing the the
>>>>> missed interrupts issue upon rmmod.
>>>>
>>>> Also, please provide the output of
>>>>
>>>> cat /proc/interrupts
>>>
>>> Note that the problem necessitating use of irqpoll in the first place
>>> seems to only happen under certain conditions. I am unsure what these
>>> conditions are. Before 'ath9k: connectivity is lost after Group
>>> rekeying is done', I had used rmmod/modprobe as my solution to the
>>> issue, which triggered the IRQ issue.
>>
>> I wonder if this is related:
>>
>> alcarin ~ # dmesg | grep GPE
>> [    0.166806] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
>> [  685.409077] ACPI: EC: GPE storm detected, disabling EC GPE
>
> FWIW, you might want to try this pach
> in this thread:
> http://www.gossamer-threads.com/lists/linux/kernel/966076
> I was receiving a disable irq #23 this patch"knock on wood",
> seems to help with this issue.
>

Both the patches there affect EHCI, though. If I was having a USB
controller fink out with "IRQ X: nobody cared", then that patch would
probably indeed be applicable.
