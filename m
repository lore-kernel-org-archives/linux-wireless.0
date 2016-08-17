Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33948 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbcHQRQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 13:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <20160817181109.080edf7a@jkicinski-Precision-T1700>
References: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
 <1471360704-10507-2-git-send-email-jakub.kicinski@netronome.com>
 <8737m3bsau.fsf@kamboji.qca.qualcomm.com> <CA+55aFwSUKorb-jho0eHzdzGNKr4c1UO8d0CRe=fsLPmUheKeg@mail.gmail.com>
 <20160817181109.080edf7a@jkicinski-Precision-T1700>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Aug 2016 10:16:08 -0700
Message-ID: <CA+55aFz_MUXQjWjbQzb7f=+cQLtxQsba1azmbEVZOgy5Y7wfdQ@mail.gmail.com> (sfid-20160817_191627_939264_682B5696)
Subject: Re: [PATCHv6 1/2] add basic register-field manipulation macros
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dinan.gunawardena@netronome.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 17, 2016 at 10:11 AM, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> On Wed, 17 Aug 2016 09:33:26 -0700, Linus Torvalds wrote:
>>
>> I'm not a huge fan, since the interface fundamentally seems to be
>> oddly designed (why pass in the mask rather than "start bit +
>> length"?).
>
> Would that not require start and length to have separate defines?

Yeah.

> I assume doing:
>
>     #define REG_BLA_FIELD_FOO  3, 4
>     val = FIELD_GET(REG_BLA_FIELD_FOO, reg);
>
> is not acceptable.  Attempts to define a single value brought us to the
> shifted mask.

Agreed. Maybe the mask with the complexity to then undo it (at compile
time) is the better approach.

            Linus
