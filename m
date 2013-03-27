Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37446 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3C0Rxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:53:40 -0400
Message-ID: <5153321B.5010206@hauke-m.de> (sfid-20130327_185343_954625_99137B55)
Date: Wed, 27 Mar 2013 18:53:31 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] b43: mark some functions and structs static
References: <1364400951-25488-1-git-send-email-hauke@hauke-m.de> <20130327172740.GE1868@tuxdriver.com> <CACna6ryua5Bok2w1B4g1C6_tyqkAbBT6B+7GjBARH02s70ua+A@mail.gmail.com>
In-Reply-To: <CACna6ryua5Bok2w1B4g1C6_tyqkAbBT6B+7GjBARH02s70ua+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2013 06:43 PM, Rafał Miłecki wrote:
> 2013/3/27 John W. Linville <linville@tuxdriver.com>:
>> On Wed, Mar 27, 2013 at 05:15:50PM +0100, Hauke Mehrtens wrote:
>>> This fixes some sparse warnings.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>>  drivers/net/wireless/b43/phy_n.c          |    6 ++++--
>>>  drivers/net/wireless/b43/radio_2056.c     |    2 +-
>>>  drivers/net/wireless/b43/sdio.h           |    4 ++--
>>>  drivers/net/wireless/b43/tables_nphy.c    |    4 ++--
>>>  drivers/net/wireless/b43/tables_phy_lcn.c |    6 +++---
>>>  5 files changed, 12 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>>> index 1ec0d69..8d15878 100644
>>> --- a/drivers/net/wireless/b43/phy_n.c
>>> +++ b/drivers/net/wireless/b43/phy_n.c
>>> @@ -2789,9 +2789,11 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
>>>   * Tx and Rx
>>>   **************************************************/
>>>
>>> -void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>> +#if 0
>>> +static void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>>  {//TODO
>>>  }
>>> +#endif
>>>
>>>  static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>>>  {//TODO
>>
>> If this isn't necessary, why not just remove it?
> 
> They are used for pointers that AFAIR can't be null.

The set_rx_antenna is not set for the n-phy and it is checked for null
before calling it and b43_nphy_set_rxantenna() is not referenced, so it
could be removed. The others are probably needed.

Hauke
