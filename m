Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754312AbcK1MYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 07:24:40 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Barry Day <briselec@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: rtl8xxxu: tx rate reported before set
References: <20161126021158.GA12838@box64.home.org>
        <20161128115312.5FE3B6114D@smtp.codeaurora.org>
Date: Mon, 28 Nov 2016 07:24:39 -0500
In-Reply-To: <20161128115312.5FE3B6114D@smtp.codeaurora.org> (Kalle Valo's
        message of "Mon, 28 Nov 2016 11:53:12 +0000 (UTC)")
Message-ID: <wrfjvav7rdvc.fsf@redhat.com> (sfid-20161128_132444_439351_98F4D642)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Barry Day <briselec@gmail.com> wrote:
>> Move the dev_info call that attempts to show the rate used before it is set.
>> 
>> Signed-off-by: Barry Day <briselec@gmail.com>
>
> Jes, I would like to take this directly to fix the compiler warning. Also I'll
> change the commit log to:

Kalle,

I'm totally fine with this, please go ahead.

Barry thanks for fixing this.

Cheers,
Jes

> rtl8xxxu: tx rate reported before set
>
> Move the dev_info call that attempts to show the rate used before it is set.
> Fixes a compiler warning:
>
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function
> 'rtl8xxxu_fill_txdesc_v2':
> include/linux/device.h:1214:36: warning: 'rate' may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>
> Fixes: b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order
> to have access to retry count")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Barry Day <briselec@gmail.com>
