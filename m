Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:20154 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYG3N7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:59:08 -0400
Received: by wf-out-1314.google.com with SMTP id 27so44159wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 06:59:08 -0700 (PDT)
Message-ID: <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com> (sfid-20080730_155914_409245_6E769BBB)
Date: Wed, 30 Jul 2008 16:59:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217425854.10489.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 4:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-07-30 at 16:45 +0300, Tomas Winkler wrote:
>> > Do you not agree that giving an aggregation flow
>> > a separate qdisc is unfair within that AC?
>>
>> I'm think your miss understanding is that HW FIFO != HW QUEUE.
>> HW FIFO takes gives fairness in level of AC.. HW QUEUE just piles up
>> packets for HW scheduler.
>
> I know, but I cannot make out how the hw queue is pulled into the hw
> fifo fairly. I'm not talking about fair media access, I'm talking about
> fair number of frames in congestion.
>
>> qdisc should be just provide simple buffering
>
> Well qdiscs don't just do that, depending on the configuration, so we
> shouldn't rely on them doing just that.

I know but this was the primary purpose of MQ to push the scheduling
decision to HW if I'm not mistaken.
We really don't need anything else just queueing. For example what the
prioritization which is done in current wme.c
is wrong and it won't pass certification and creates starvation.
Tested and proved.
Tomas
