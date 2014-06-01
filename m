Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44361 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaFAAiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 20:38:13 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so3511759wgg.6
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 17:38:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140531200556.GL17724@mwanda>
References: <1401553786-7603-1-git-send-email-andrea.merello@gmail.com> <20140531200556.GL17724@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sun, 1 Jun 2014 02:37:51 +0200
Message-ID: <CAN8YU5OFqTa0Ywwhgt_MzTA5+5v9YON_YkQyD3L+syCyjO+OKw@mail.gmail.com> (sfid-20140601_024032_579005_E4F3F0B9)
Subject: Re: [PATCH 1/3] rtl818x_pci: make RSSI code more readable
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IHMO it does not matter.

The 10 is a stub value for rtl8187se (because of not-implemented-yet
RSSI calculation), and indeed it is still here, in the rtl8187se case.
This has the functional role of providing a valid >0 value for reported RSSI.
This should hopefully go away soon :)
So, for rtl8187se case, it always reported 10, and it does continue to do this.

The initialization to 1 has no any functional role, it is just to shut
up gcc complaints about not initialized variable, but it should be
always overwritten by one of the three cases, and we should never see
this value really reported on RSSI measure.

Indeed they are two random values (chosen >0, just in case it does matter..)..

Andrea

On Sat, May 31, 2014 at 10:05 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Sat, May 31, 2014 at 06:29:46PM +0200, Andrea Merello wrote:
>> remove the if-else chains and use switch-case to make code more
>> readable and avoiding long lines that broke in several lines
>>
>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>> ---
>>  drivers/net/wireless/rtl818x/rtl8180/dev.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
>> index 2c1c02b..c2dd5e6 100644
>> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
>> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
>> @@ -209,7 +209,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>>       struct rtl8180_priv *priv = dev->priv;
>>       struct rtl818x_rx_cmd_desc *cmd_desc;
>>       unsigned int count = 32;
>> -     u8 signal, agc, sq;
>> +     u8 agc, sq, signal = 1;
>
> Shouldn't the 1 be 10?  Why did the defaults change?
>
> regards,
> dan carpenter
>
>>       dma_addr_t mapping;
>>
>>       while (count--) {
>> @@ -266,18 +266,21 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>>                       rx_status.rate_idx = (flags >> 20) & 0xF;
>>                       agc = (flags2 >> 17) & 0x7F;
>>
>> -                     if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
>> +                     switch (priv->chip_family) {
>> +                     case RTL818X_CHIP_FAMILY_RTL8185:
>>                               if (rx_status.rate_idx > 3)
>>                                       signal = 90 - clamp_t(u8, agc, 25, 90);
>>                               else
>>                                       signal = 95 - clamp_t(u8, agc, 30, 95);
>> -                     } else if (priv->chip_family ==
>> -                                RTL818X_CHIP_FAMILY_RTL8180) {
>> +                             break;
>> +                     case RTL818X_CHIP_FAMILY_RTL8180:
>>                               sq = flags2 & 0xff;
>>                               signal = priv->rf->calc_rssi(agc, sq);
>> -                     } else {
>> +                             break;
>> +                     case RTL818X_CHIP_FAMILY_RTL8187SE:
>>                               /* TODO: rtl8187se rssi */
>>                               signal = 10;
>> +                             break;
>>                       }
>>                       rx_status.signal = signal;
>>                       rx_status.freq = dev->conf.chandef.chan->center_freq;
>> --
>> 1.9.1
