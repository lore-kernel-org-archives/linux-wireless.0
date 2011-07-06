Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54956 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1GFQCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 12:02:42 -0400
Received: by pzk9 with SMTP id 9so56513pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 09:02:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110706175810.76749948@maggie>
References: <1309902848-3141-1-git-send-email-zajec5@gmail.com>
	<1309902848-3141-2-git-send-email-zajec5@gmail.com>
	<20110706174046.0ae24b6d@maggie>
	<CACna6ryHRNLNPrPam2dAWLysqtFLtE8bcu4A26A4xFj2ui2eNg@mail.gmail.com>
	<20110706175810.76749948@maggie>
Date: Wed, 6 Jul 2011 18:02:41 +0200
Message-ID: <CACna6rwpDdB60s135FW0q=PHJNJxGo6QUHnZ9fYFPAQZyfujMQ@mail.gmail.com> (sfid-20110706_180245_218206_3DB492D0)
Subject: Re: [PATCH 2/2] b43: implement BCMA bus ops
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 lipca 2011 17:58 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Wed, 6 Jul 2011 17:52:40 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> >> +/* BCMA */
>> >> +#ifdef CONFIG_B43_BCMA
>> >> +static inline int b43_bus_bcma_bus_may_powerdown(struct b43_bus_dev *dev)
>> >> +{
>> >> +     return 0; /* bcma_bus_may_powerdown(dev->bdev->bus); */
>> >> +}
>> >
>> > Why is this inline?
>> > You can't inline and take a pointer of the function at the same time.
>> > (The compiler will workaround this by generating multiple versions of
>> > the function, of which at least one is not inline).
>> > So remove it, please. Same below...
>>
>> I didn't know about any such a limitation.
>
> This is not a limitation. It's just the way it is. You can't take
> a reference to an object, that doesn't exist as an independent object.
>
> So in this case, if there are no static callers of your function, the
> compiler will simply ignore the inline. However, if there were other static
> callers (in addition to the indirect callers through pointer), the compiler
> would generate (most likely) an inline version for the static callers
> and additionally a non-inline version for the indirect callers.
>
>> Just for sure: did you really mean "pointer of the function"? Cause my
>> function is taking pointer of the struct, not pointer of function.
>
> You are taking the pointer to the function (C adds the & for you, so you only
> need the function name) and put it into the bus struct.

Ohh, I though you mean getting function pointer as argument of
b43_bus_bcma_bus_may_powerdown
function.

Of course you meant taking pointer in this place:
dev->bus_may_powerdown = b43_bus_bcma_bus_may_powerdown;


Now I see the problem, thanks.

-- 
Rafał
