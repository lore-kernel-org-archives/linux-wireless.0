Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64035 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZH0Ulk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 16:41:40 -0400
Received: by bwz19 with SMTP id 19so1229303bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 13:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908272231.19632.mb@bu3sch.de>
References: <4A96D6D6.3050201@gmail.com> <200908272231.19632.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 27 Aug 2009 22:41:17 +0200
Message-ID: <69e28c910908271341i23fd709ag8444b00bad3c7f48@mail.gmail.com>
Subject: Re: [PATCH] b43: Implement antenna diversity support for LP-PHY
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Michael Buesch <mb@bu3sch.de>:
> On Thursday 27 August 2009 20:56:22 Gábor Stefanik wrote:
>> The A/G-PHY changes are fallout fixes from the enum change,
>> which in turn allows the LP-PHY code to be much simpler.
>> The antenna_to_phyctl change is a fix for a potential
>> existing bug that this patch may otherwise trigger.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> Note that according to recent spec changes, the A/G-PHY
>> antenna diversity routines also need to be updated.
>> However, I'm not lumping those changes into this patch
>> (this is for LP-PHY).
>>
>>  drivers/net/wireless/b43/main.c       |    3 ++-
>>  drivers/net/wireless/b43/phy_a.c      |    2 +-
>>  drivers/net/wireless/b43/phy_common.h |   10 +++++-----
>>  drivers/net/wireless/b43/phy_g.c      |    2 +-
>>  drivers/net/wireless/b43/phy_lp.c     |   11 ++++++++++-
>>  5 files changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index 289e06c..3b038c9 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -1456,7 +1456,8 @@ static u16 b43_antenna_to_phyctl(int antenna)
>>               return B43_TXH_PHY_ANT2;
>>       case B43_ANTENNA3:
>>               return B43_TXH_PHY_ANT3;
>> -     case B43_ANTENNA_AUTO:
>> +     case B43_ANTENNA_AUTO0:
>> +     case B43_ANTENNA_AUTO1:
>>               return B43_TXH_PHY_ANT01AUTO;
>>       }
>>       B43_WARN_ON(1);
>> diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
>> index 816e028..809ec97 100644
>> --- a/drivers/net/wireless/b43/phy_a.c
>> +++ b/drivers/net/wireless/b43/phy_a.c
>> @@ -531,7 +531,7 @@ static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
>>
>>       tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
>>       tmp &= ~B43_PHY_BBANDCFG_RXANT;
>> -     tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
>> +     tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
>>           << B43_PHY_BBANDCFG_RXANT_SHIFT;
>>       b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
>>
>> diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
>> index b47a0f5..28e3846 100644
>> --- a/drivers/net/wireless/b43/phy_common.h
>> +++ b/drivers/net/wireless/b43/phy_common.h
>> @@ -49,11 +49,11 @@ enum b43_interference_mitigation {
>>
>>  /* Antenna identifiers */
>>  enum {
>> -     B43_ANTENNA0,           /* Antenna 0 */
>> -     B43_ANTENNA1,           /* Antenna 0 */
>> -     B43_ANTENNA_AUTO1,      /* Automatic, starting with antenna 1 */
>> -     B43_ANTENNA_AUTO0,      /* Automatic, starting with antenna 0 */
>> -     B43_ANTENNA2,
>> +     B43_ANTENNA0 = 0,       /* Antenna 0 */
>> +     B43_ANTENNA1 = 1,       /* Antenna 1 */
>> +     B43_ANTENNA_AUTO0 = 2,  /* Automatic, starting with antenna 0 */
>> +     B43_ANTENNA_AUTO1 = 3,  /* Automatic, starting with antenna 1 */
>> +     B43_ANTENNA2 = 4,
>>       B43_ANTENNA3 = 8,
>>
>>       B43_ANTENNA_AUTO = B43_ANTENNA_AUTO0,
>> diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
>> index c6c9d2f..c6d639d 100644
>> --- a/drivers/net/wireless/b43/phy_g.c
>> +++ b/drivers/net/wireless/b43/phy_g.c
>> @@ -2651,7 +2651,7 @@ static void b43_gphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
>>
>>       tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
>>       tmp &= ~B43_PHY_BBANDCFG_RXANT;
>> -     tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
>> +     tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
>>                       << B43_PHY_BBANDCFG_RXANT_SHIFT;
>>       b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
>>
>> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
>> index 837d952..055c0f7 100644
>> --- a/drivers/net/wireless/b43/phy_lp.c
>> +++ b/drivers/net/wireless/b43/phy_lp.c
>> @@ -2204,7 +2204,16 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
>>
>>  static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
>>  {
>> -     //TODO
>> +     int autodiv = ;
>
> Does this compile?

That's a typo. Also, the autodiv variable shouldn't be there at all.
Will respin.

>
>> +
>> +     if (dev->phy.rev >= 2)
>> +             return; // rev2+ doesn't support antenna diversity
>> +
>> +     if (B43_WARN_ON(antenna > B43_ANTENNA_AUTO1))
>> +             return;
>> +
>> +     b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFD, antenna & 0x2);
>> +     b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFE, antenna & 0x1);
>>  }
>>
>>  static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)
>
>
>
> --
> Greetings, Michael.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
