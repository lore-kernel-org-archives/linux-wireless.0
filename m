Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:38815 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3C1KAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 06:00:10 -0400
Received: by mail-oa0-f54.google.com with SMTP id n12so9765057oag.13
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 03:00:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5153321B.5010206@hauke-m.de>
References: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
	<20130327172740.GE1868@tuxdriver.com>
	<CACna6ryua5Bok2w1B4g1C6_tyqkAbBT6B+7GjBARH02s70ua+A@mail.gmail.com>
	<5153321B.5010206@hauke-m.de>
Date: Thu, 28 Mar 2013 11:00:09 +0100
Message-ID: <CACna6rzhTg-L+p5Sz7zTEgP4PJvVvXuhVtgSCcr3g3FhAmCSww@mail.gmail.com> (sfid-20130328_110015_770632_E74CC54E)
Subject: Re: [PATCH 1/2] b43: mark some functions and structs static
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/27 Hauke Mehrtens <hauke@hauke-m.de>:
> On 03/27/2013 06:43 PM, Rafał Miłecki wrote:
>> 2013/3/27 John W. Linville <linville@tuxdriver.com>:
>>> On Wed, Mar 27, 2013 at 05:15:50PM +0100, Hauke Mehrtens wrote:
>>>> This fixes some sparse warnings.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> ---
>>>>  drivers/net/wireless/b43/phy_n.c          |    6 ++++--
>>>>  drivers/net/wireless/b43/radio_2056.c     |    2 +-
>>>>  drivers/net/wireless/b43/sdio.h           |    4 ++--
>>>>  drivers/net/wireless/b43/tables_nphy.c    |    4 ++--
>>>>  drivers/net/wireless/b43/tables_phy_lcn.c |    6 +++---
>>>>  5 files changed, 12 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>>>> index 1ec0d69..8d15878 100644
>>>> --- a/drivers/net/wireless/b43/phy_n.c
>>>> +++ b/drivers/net/wireless/b43/phy_n.c
>>>> @@ -2789,9 +2789,11 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
>>>>   * Tx and Rx
>>>>   **************************************************/
>>>>
>>>> -void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>>> +#if 0
>>>> +static void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>>>  {//TODO
>>>>  }
>>>> +#endif
>>>>
>>>>  static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>>>>  {//TODO
>>>
>>> If this isn't necessary, why not just remove it?
>>
>> They are used for pointers that AFAIR can't be null.
>
> The set_rx_antenna is not set for the n-phy and it is checked for null
> before calling it and b43_nphy_set_rxantenna() is not referenced, so it
> could be removed. The others are probably needed.

Whoops, I didn't know that fact about b43_nphy_set_rxantenna. Yeah, it
should be removed.

-- 
Rafał
