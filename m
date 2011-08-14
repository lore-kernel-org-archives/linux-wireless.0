Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1HNCjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 22:39:24 -0400
Received: by yxj19 with SMTP id 19so2692262yxj.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 19:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110813184140.GC16149@vmraj-lnx.users.atheros.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmo=yP7q33FBwDCCnu3f+=E6ONuLK+xj6ye-26bSW_kgtdQ@mail.gmail.com>
	<20110813184140.GC16149@vmraj-lnx.users.atheros.com>
Date: Sun, 14 Aug 2011 10:39:23 +0800
Message-ID: <CAJ-Vmo=O5fWb6P=WdVQF64vk+j--pmsnQzV158Bfi2i2rPDJ6w@mail.gmail.com> (sfid-20110814_043930_215665_B1AC8E81)
Subject: Re: [PATCH 01/11] ath9k_hw: Fix exceed transmission burst-time of 5GHz
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 August 2011 02:42, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:

>> FreeBSD doesn't (yet) enable that bit. ath9k doesn't seem to enable
>> that bit, either in code or in the ar5008/ar9001/ar9002/ar9003
>> initvals.
>>
> Correct. So the frames that are exceeding txop limit are not filtered.
> The issue was originally observed while measuring XPABIAS5 signal of
> AR9380 at 5GHz HT20 MCS0. It exceeds the 4ms limit due to WAR delimits.

Ah, makes sense now. Well, we (collectively) should likely figure out
how to teach the rate control and TX code how to not exceed TXOP in
general.
Do packets that exceed TXOP get marked as filtered?

Thanks for finding that. :)



Adrian
