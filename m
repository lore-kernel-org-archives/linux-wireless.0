Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47040 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1LKEIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 23:08:50 -0500
Received: by iaeh11 with SMTP id h11so1119730iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 20:08:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE41E4D.3050702@lwfinger.net>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
 <1323568535-2816-8-git-send-email-zajec5@gmail.com> <4EE41E4D.3050702@lwfinger.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 11 Dec 2011 15:08:29 +1100
Message-ID: <CAGRGNgXWfW5vPabfoL7d8-Nuu0hL40NHBe_=8Od8bxF+Y3H3qg@mail.gmail.com> (sfid-20111211_050858_791647_21A3425C)
Subject: Re: [PATCH 7/7] b43: N-PHY: implement spurious tone avoidance
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

2011/12/11 Larry Finger <Larry.Finger@lwfinger.net>:
> On 12/10/2011 07:55 PM, Rafał Miłecki wrote:
>>
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_n.c |   90
>> +++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 88 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c
>> b/drivers/net/wireless/b43/phy_n.c
>> index 114c413..6e776d0 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -4023,6 +4023,58 @@ int b43_phy_initn(struct b43_wldev *dev)
>>        return 0;
>>  }
>>
>> [snip]
>
> My gcc is brain dead here and outputs
>
> [snip] variable may be used uninitialised warning

It's not brain dead =)

> The variable is clearly set in all paths, but I still get the warning.

It's set in all paths, but there is no way to guarantee that one of
the paths will be taken - they all have conditions.

Something like the following might be better:

>> +static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
>> +{
>> +       struct bcma_drv_cc *cc =&dev->dev->bdev->bus->drv_cc;
>>
>> +       u32 pmu_ctl;
>> +       if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
>> [snip]
>> +       } else if (dev->dev->chip_id == 0x4322 || dev->dev->chip_id ==
>> 0x4340 ||
>> +                  dev->dev->chip_id == 0x4341) {
>> +               bcma_chipco_pll_write(cc, 0x0, 0x11100070);
>> +               bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
>> +               bcma_chipco_pll_write(cc, 0x5, 0x88888854);
>> +               if (avoid)
>> +                       bcma_chipco_pll_write(cc, 0x2, 0x05201828);
>> +               else
>> +                       bcma_chipco_pll_write(cc, 0x2, 0x05001828);
>> +               pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;

+       } else {
+             B43_WARN_ON(1);
+
+             return;
+       }
+
>> +       bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
