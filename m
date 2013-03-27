Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51512 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3C0Rnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:43:43 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so9197231oag.29
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 10:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130327172740.GE1868@tuxdriver.com>
References: <1364400951-25488-1-git-send-email-hauke@hauke-m.de>
	<20130327172740.GE1868@tuxdriver.com>
Date: Wed, 27 Mar 2013 18:43:42 +0100
Message-ID: <CACna6ryua5Bok2w1B4g1C6_tyqkAbBT6B+7GjBARH02s70ua+A@mail.gmail.com> (sfid-20130327_184354_608639_99F13AF2)
Subject: Re: [PATCH 1/2] b43: mark some functions and structs static
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/27 John W. Linville <linville@tuxdriver.com>:
> On Wed, Mar 27, 2013 at 05:15:50PM +0100, Hauke Mehrtens wrote:
>> This fixes some sparse warnings.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/b43/phy_n.c          |    6 ++++--
>>  drivers/net/wireless/b43/radio_2056.c     |    2 +-
>>  drivers/net/wireless/b43/sdio.h           |    4 ++--
>>  drivers/net/wireless/b43/tables_nphy.c    |    4 ++--
>>  drivers/net/wireless/b43/tables_phy_lcn.c |    6 +++---
>>  5 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>> index 1ec0d69..8d15878 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -2789,9 +2789,11 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
>>   * Tx and Rx
>>   **************************************************/
>>
>> -void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>> +#if 0
>> +static void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>  {//TODO
>>  }
>> +#endif
>>
>>  static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>>  {//TODO
>
> If this isn't necessary, why not just remove it?

They are used for pointers that AFAIR can't be null.

-- 
Rafał
