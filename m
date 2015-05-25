Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36735 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbEYIXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 04:23:55 -0400
Received: by wizk4 with SMTP id k4so41065650wiz.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 01:23:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACZoB6-+AUWN6gBqnwgJY101jfjBkDukLYNNffbe2bWNidjJ0Q@mail.gmail.com>
References: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
	<1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
	<CACZoB6-+AUWN6gBqnwgJY101jfjBkDukLYNNffbe2bWNidjJ0Q@mail.gmail.com>
Date: Mon, 25 May 2015 10:23:54 +0200
Message-ID: <CA+BoTQkzg1jEXjem=HQZW_qTMTZfjqLzfm58FoBraBf2urdoKA@mail.gmail.com> (sfid-20150525_102359_758879_EBF65C2E)
Subject: Re: [PATCH v3 1/2] ath10k: handle cycle counter wraparound
From: Michal Kazior <michal.kazior@tieto.com>
To: Srinivasa Duvvuri <sduvvuri@google.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2015 at 19:11, Srinivasa Duvvuri <sduvvuri@google.com> wrote:
> Michal,
>    Sorry I was out sick last few days. Thanks for splitting and creating 2
> patches.
>    The math for total cycle counts makes sense but the math to handle the
> rx_clear_count
>    does not seem right to me. For the total cycle count we know that the
> count changes
>    from 0xffffffff to 0x7fffffff. So, we clearly know the wrap around point
> . But for
>    rcc( rx_clear_count)  we do not know when this count is halfed (wrapped).
>
>    Lets say rcc_prev  is the previous clear cycle count, rcc is the current
> clear cycle count
>    and rcc_wrap is a point at which the the total cycle count is wrapped
> from 0xfffffffff to 0x7fffffff .
>    At that point the rcc_wrap resets to rcc_wrap/2.
>
>     Here is how counts wrap around.
>
>    cc_prev  ............0xffffffff    -> 0x7fffffff ................ cc
>    rcc_prev ............rcc_wrap ->  rcc_wrap/2 ........... rcc.
>
>    The right math to calculate rcc_delta would be  (rcc_wrap - rcc_prev) +
> (rcc - rcc_wrap/2).
>    To do the math,  we need the rcc_wrap which we do not have.
>    the patch seems to simply do  2*rcc - rcc_prev . Unless I am missing
> something,
>    this does not seem right to me.

Ah, you're right. I guess I'll need to discard the data like you
originally did upon wraparound detection.


Michał
