Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbcK1Lou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 06:44:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Barry Day <briselec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the wireless-drivers-next tree
References: <20161128115814.2cabf139@canb.auug.org.au>
        <87d1hg83rp.fsf@kamboji.qca.qualcomm.com>
        <20161128081649.GA8403@testbox>
Date: Mon, 28 Nov 2016 13:44:40 +0200
In-Reply-To: <20161128081649.GA8403@testbox> (Barry Day's message of "Mon, 28
        Nov 2016 18:16:51 +1000")
Message-ID: <87oa0zygk7.fsf@kamboji.qca.qualcomm.com> (sfid-20161128_124515_597645_3EE30C93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:

> On Mon, Nov 28, 2016 at 09:25:30AM +0200, Kalle Valo wrote:
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>> 
>> > Hi all,
>> >
>> > After merging the wireless-drivers-next tree, today's linux-next build
>> > (x86_64 allmodconfig) produced this warning:
>> >
>> > In file included from include/linux/usb/ch9.h:35:0,
>> >                  from include/linux/usb.h:5,
>> >                  from drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:32:
>> > drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_fill_txdesc_v2':
>> > include/linux/device.h:1214:36: warning: 'rate' may be used uninitialized in this function [-Wmaybe-uninitialized]
>> >  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>> >                                     ^
>> > drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4841:6: note: 'rate' was declared here
>> >   u32 rate;
>> >       ^
>> >
>> > Introduced by commit
>> >
>> >   b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count")
>> >
>> > This is a correct diagnosis.
>> 
>> Thanks for the report. Jes, can you send a patch to fix this? (Unless
>> someone else beats to it.)
>> 
>> -- 
>> Kalle Valo
>
> I posted a patch on the 26th that fixes this

Thanks, I see it:

https://patchwork.kernel.org/patch/9448225/

The commit log doesn't mention anything about the compilation warning,
I'll add that. Also a Fixes line is nice to have.

-- 
Kalle Valo
