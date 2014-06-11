Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:50285 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaFKIuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:50:18 -0400
Received: by mail-la0-f41.google.com with SMTP id hz20so239453lab.14
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:50:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=rzHzSr67W9KoC8u5cARrckOgQA-m26fmhXwX85aEcKoA@mail.gmail.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com> <CALhHN=rzHzSr67W9KoC8u5cARrckOgQA-m26fmhXwX85aEcKoA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 11 Jun 2014 01:49:56 -0700
Message-ID: <CAB=NE6VwBB-_G6JfLo81PYsjxBbw+C4Y40ZogNh4-eG910rXuw@mail.gmail.com> (sfid-20140611_105024_616605_91FB09DC)
Subject: Re: [RFC 1/2] crda: simplify text parsing for country/rules
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:03 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 11 June 2014 00:09, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>> On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
>> <janusz.dziedzic@tieto.com> wrote:
>>> Remove strange parsers.
>>>
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> Did you test this with the different types of accepted rules?
>>
>
> Tested with current db.txt (+AUTO-BW in some cases).

I was curious more about the different use cases of the output power,
sometimes we use dBm, sometimes mW I think. I think I tried your
approach and ended up getting inconsistent results for the different
cases, so that's why all the parser junk got added. If you found a way
to successfully get rid of it though that's awesome, just want to be
sure we tested all cases. I purposely tried to upkeep the output to
match the input preference, some folks are picky about mW and others
like dB, this helps with regulatory rules as they vary depending on
the country and the country typically uses one or the other for the
definitions.

  Luis
