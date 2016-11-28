Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754312AbcK1M0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 07:26:11 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Barry Day <briselec@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the wireless-drivers-next tree
References: <20161128115814.2cabf139@canb.auug.org.au>
        <87d1hg83rp.fsf@kamboji.qca.qualcomm.com>
        <20161128081649.GA8403@testbox>
        <87oa0zygk7.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 28 Nov 2016 07:26:09 -0500
In-Reply-To: <87oa0zygk7.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 28 Nov 2016 13:44:40 +0200")
Message-ID: <wrfjr35vrdsu.fsf@redhat.com> (sfid-20161128_132615_501763_7941368F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Barry Day <briselec@gmail.com> writes:
>
>> On Mon, Nov 28, 2016 at 09:25:30AM +0200, Kalle Valo wrote:
>>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>> 
>>> > Hi all,
>>> >
>>> > After merging the wireless-drivers-next tree, today's linux-next build
>>> > (x86_64 allmodconfig) produced this warning:
>>> >
>>> > In file included from include/linux/usb/ch9.h:35:0,
>>> >                  from include/linux/usb.h:5,
>>> >                  from drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:32:
>>> > drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_fill_txdesc_v2':
>>> > include/linux/device.h:1214:36: warning: 'rate' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>> >  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>>> >                                     ^
>>> > drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4841:6: note: 'rate' was declared here
>>> >   u32 rate;
>>> >       ^
>>> >
>>> > Introduced by commit
>>> >
>>> >   b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count")
>>> >
>>> > This is a correct diagnosis.
>>> 
>>> Thanks for the report. Jes, can you send a patch to fix this? (Unless
>>> someone else beats to it.)
>>> 
>>> -- 
>>> Kalle Valo
>>
>> I posted a patch on the 26th that fixes this
>
> Thanks, I see it:
>
> https://patchwork.kernel.org/patch/9448225/
>
> The commit log doesn't mention anything about the compilation warning,
> I'll add that. Also a Fixes line is nice to have.

I'm happy with this fix

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
