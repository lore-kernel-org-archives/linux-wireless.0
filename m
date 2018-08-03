Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbeHCSVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 14:21:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] mt76x0: raname mt76_* functions
References: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
        <87r2jf5t6w.fsf@kamboji.qca.qualcomm.com>
        <20180803161828.GA2389@redhat.com>
Date: Fri, 03 Aug 2018 19:24:19 +0300
In-Reply-To: <20180803161828.GA2389@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 3 Aug 2018 18:18:29 +0200")
Message-ID: <87muu35sgc.fsf@kamboji.qca.qualcomm.com> (sfid-20180803_182426_807009_BA588A13)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Fri, Aug 03, 2018 at 07:08:23PM +0300, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>> > mt76_* functions conflicts with mt7601u driver what prevents to build
>> > those drivers in the kernel or use both drivers modules at once.
>> >
>> > Patch fixes build errors like this:
>> > ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x30):
>> > multiple definition of `mt76_mac_tx_rate_val';
>> > drivers/net/wireless/mediatek/mt7601u/mac.o:(.opd+0x30): first
>> > defined here
>> >
>> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> 
>> Thanks. I'll add this to both patches:
>> 
>> Fixes: 7b4859026ccd ("mt76x0: core files")
>
> Please also fix typo in the topic raname -> rename

Oh, I didn't even notice that. Will fix.

The patches are now in w-d-next pending branch and I'll also run some
build tests myself. If everything goes ok I'll apply these.

-- 
Kalle Valo
