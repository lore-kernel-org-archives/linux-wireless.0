Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:31552 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbYGIUzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:41 -0400
Received: by el-out-1112.google.com with SMTP id z25so532055ele.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 13:55:40 -0700 (PDT)
Message-ID: <fce2a370807091355o47f38f6ei3ce83b4b27466bf8@mail.gmail.com> (sfid-20080709_225555_677007_1CD3076F)
Date: Wed, 9 Jul 2008 23:55:40 +0300
From: "Ihar Hrachyshka" <ihar.hrachyshka@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org,
	"Ihar Hrachyshka" <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1215634044.3246.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080709031850.2e7bf50f@promwad.com>
	 <200807091521.04520.hs4233@mail.mn-solutions.de>
	 <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com>
	 <1215634044.3246.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 9, 2008 at 11:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-07-09 at 23:03 +0300, Ihar Hrachyshka wrote:
>> On Wed, Jul 9, 2008 at 4:21 PM, Holger Schurig
>> <hs4233@mail.mn-solutions.de> wrote:
>> >> Fixing unaligned memory access on the blackfin architecture
>> >> (maybe on the ARM also).
>> >
>> > You can delete the "maybe", on ARM (more specificially, on a
>> > PXA255, which is ARMv5TE) I didn't had a problem.
>>
>> Ok, just blackfin. Is it a joke or should I resend the patch with
>> another description?..
>
> I'm sure arm has that problem too and sparc and others, but it may not
> always show up because the frame might actually be aligned sometimes.
>
> OTOH, why are you getting unaligned frames in the first place? This is
> the beacon interval, so it's at a fixed modulo-two position from the
> start of the frame.

Do you mean that we should add __attribute__ ((aligned (2))) for our
'bss_descriptor' structure definition rather align particular fields
at runtime?

>
> johannes
>
