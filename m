Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50345 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1GQQmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 12:42:51 -0400
Received: by pvg12 with SMTP id 12so2376505pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 09:42:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110717104359.72a27182@maggie>
References: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
	<20110717104359.72a27182@maggie>
Date: Sun, 17 Jul 2011 18:42:50 +0200
Message-ID: <CACna6rxUDaaRmEfF86=wCZ50iN7LFT_jh0u7U34otg6ovbWe=A@mail.gmail.com> (sfid-20110717_184255_526830_21B57488)
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

Yeah, I implemented it this way as the result of my rush in writing HT
code. We can ignore wl's ops and be smarter in such a cases.

-- 
Rafał
