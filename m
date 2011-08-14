Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1HNEGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 00:06:33 -0400
Date: Sun, 14 Aug 2011 09:36:30 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] ath9k_hw: Fix exceed transmission burst-time of
 5GHz
Message-ID: <20110814040628.GA16803@vmraj-lnx.users.atheros.com> (sfid-20110814_060636_912038_3BDBF42C)
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=yP7q33FBwDCCnu3f+=E6ONuLK+xj6ye-26bSW_kgtdQ@mail.gmail.com>
 <20110813184140.GC16149@vmraj-lnx.users.atheros.com>
 <CAJ-Vmo=O5fWb6P=WdVQF64vk+j--pmsnQzV158Bfi2i2rPDJ6w@mail.gmail.com>
 <CAJ-VmomsHZGy3oU65oXk1kAhrbXKuVNvLJdPjGn8UyEdYF6_iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJ-VmomsHZGy3oU65oXk1kAhrbXKuVNvLJdPjGn8UyEdYF6_iA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 14, 2011 at 10:39:51AM +0800, Adrian Chadd wrote:
> On 14 August 2011 10:39, Adrian Chadd <adrian@freebsd.org> wrote:
> 
> > Ah, makes sense now. Well, we (collectively) should likely figure out
> > how to teach the rate control and TX code how to not exceed TXOP in
> > general.
> > Do packets that exceed TXOP get marked as filtered?
> 
> .. when the relevant bit in AR_PCU_MISCMODE is enabled, that is?
> (Obviously they're not being filtered now..)
>
If TXOP_TBTT_LIMIT bit is set then the logic to limit the value of the duration
to fit in the time remaining in TXOP and time remaining until TBTT will be
turned on. This logic will also will filter frames which will exceed TXOP.

--
Rajkumar
