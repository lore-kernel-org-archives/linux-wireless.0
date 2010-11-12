Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50765 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0KLC1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 21:27:41 -0500
Received: by iwn10 with SMTP id 10so2900107iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 18:27:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikkH2GPTh0cPHODqJLe_Xte27qnHLSfuxqzzJYV@mail.gmail.com>
References: <185731CC-606D-407D-80F4-33FEF08ED35D@moxienet.com>
 <AANLkTik35wHXiznjGm7nc9HBYUy7iQk65FVSq7T2Gw8u@mail.gmail.com>
 <AANLkTikf13HMEtVkpTftKrZenvPwPcHbuhgqmh2m-UYU@mail.gmail.com>
 <AANLkTin_5Nhwby79eYY972ZFh-0Tr4MaauSn4LAtsn-7@mail.gmail.com>
 <AANLkTin8+ecx5e04CJM8sv2LrY=+xnJ7cD2CPcMHHcYe@mail.gmail.com> <AANLkTikkH2GPTh0cPHODqJLe_Xte27qnHLSfuxqzzJYV@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 18:27:20 -0800
Message-ID: <AANLkTikuEpe-SPZKmhvYizGARvW-fKszTB=OO2oVvNVo@mail.gmail.com>
Subject: Re: Regulatory/CRDA Race
To: Mark Mentovai <mark@moxienet.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 4:04 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>> On Mon, Nov 8, 2010 at 11:40 AM, Mark Mentovai <mark@moxienet.com> wrote:
>>>>>> 3. The second card’s driver (also ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request sees that the last request came from a driver (instead of the core) and since the regulatory domain is changing from 00 to US, decides that intersection must be performed.
>
> This interpretation however is incorrect, as a driver hint shall
> always be respected if the current regulatory domain is 00. We do end
> up with an intersection but there is another reason and that is the
> bug. I will try to track it down.

OK fixed, please try the posted patch.

  Luis
