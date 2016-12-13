Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932900AbcLMRED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 12:04:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] orinoco: Use shash instead of ahash for MIC calculations
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
        <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
        <87mvg0kqno.fsf@purkki.adurom.net>
        <CALCETrXxQ9FxuqV5A1rkj2SpeFfd89njDP9h5VBuNx387ieKdQ@mail.gmail.com>
Date: Tue, 13 Dec 2016 19:03:53 +0200
In-Reply-To: <CALCETrXxQ9FxuqV5A1rkj2SpeFfd89njDP9h5VBuNx387ieKdQ@mail.gmail.com>
        (Andy Lutomirski's message of "Tue, 13 Dec 2016 08:41:01 -0800")
Message-ID: <87eg1bzrpi.fsf@kamboji.qca.qualcomm.com> (sfid-20161213_180433_377583_DEED0F84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Dec 13, 2016 at 3:35 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Andy Lutomirski <luto@kernel.org> writes:
>>
>>> Eric Biggers pointed out that the orinoco driver pointed scatterlists
>>> at the stack.
>>>
>>> Fix it by switching from ahash to shash.  The result should be
>>> simpler, faster, and more correct.
>>>
>>> Cc: stable@vger.kernel.org # 4.9 only
>>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>
>> "more correct"? Does this fix a real user visible bug or what? And why
>> just stable 4.9, does this maybe have something to do with
>> CONFIG_VMAP_STACK?
>
> Whoops, I had that text in some other patches but forgot to put it in
> this one.  It'll blow up with CONFIG_VMAP_STACK=y if a debug option
> like CONFIG_DEBUG_VIRTUAL=y is set.  It may work by accident if
> debugging is off.

Makes sense now, thanks. I'll add that to the commit log and queue this
to 4.10.

-- 
Kalle Valo
