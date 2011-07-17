Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1GQQ4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 12:56:51 -0400
Received: by pvg12 with SMTP id 12so2381939pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 09:56:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110717104359.72a27182@maggie>
References: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
	<20110717104359.72a27182@maggie>
Date: Sun, 17 Jul 2011 18:56:50 +0200
Message-ID: <CACna6ry9Vet9mCkmUZKgTxAiZjSEhb2svNSPAQDVpiV+8JZ0Kg@mail.gmail.com> (sfid-20110717_185654_637449_455657EC)
Subject: Re: [PATCH 1/4] b43: HT-PHY: fix masks in radio ctl
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 lipca 2011 10:43 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sun, 17 Jul 2011 10:30:31 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> Old masks were causing ugly, delayed lock ups.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_ht.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
>> index 2982103..0cc293a 100644
>> --- a/drivers/net/wireless/b43/phy_ht.c
>> +++ b/drivers/net/wireless/b43/phy_ht.c
>> @@ -277,12 +277,12 @@ static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
>>               b43err(dev->wl, "MAC not suspended\n");
>>
>>       if (blocked) {
>> -             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
>> +             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
>>       } else {
>> -             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
>> -             b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x1);
>> -             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
>> -             b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x2);
>> +             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
>> +             b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, 0, 0x1);
>> +             b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
>> +             b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, 0, 0x2);
>>
>>               if (dev->phy.radio_ver == 0x2059)
>>                       b43_radio_2059_init(dev);
>
> Why are we using mask/maskset here at all, if the mask is zero?
> You could just use phy_write.
>
> (And mask() with ~0 should always ring a bell anyway, because it does
> nothing except for possible side effects of the register read/write).

Well, after re-thinking it, I've some doubts.

Thanks to using maskset we got read after every write. We have no idea
it this is needed or no. What we are really sure is that this part of
code is really sensitive. Writing 0x3 cause horrible lock ups, really
ugly to track.

Should we use read-after-write then? Or maybe just keep wl's dummy way
of operating on this register?

-- 
Rafał
