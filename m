Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32901 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbbKGSOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 13:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <20151107135427.GH18797@mwanda>
References: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
	<20151107135427.GH18797@mwanda>
Date: Sat, 7 Nov 2015 23:44:04 +0530
Message-ID: <CABXAfNJWe78txO91YixoEZTO1n7q69LqN89UpDanrT8cA-jnyA@mail.gmail.com> (sfid-20151107_191426_490423_670D7ECA)
Subject: Re: [PATCH] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 7, 2015 at 7:24 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Nov 07, 2015 at 05:01:49PM +0530, Punit Vara wrote:
>>  int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
>>  {
>> @@ -1791,6 +1794,7 @@ int wilc_netdev_init(struct wilc **wilc)
>>  /*The 1st function called after module inserted*/
>>  static int __init init_wilc_driver(void)
>>  {
>> +     struct wilc *wilc;
>>  #ifdef WILC_SPI
>>       struct wilc *wilc;
>>  #endif
>
> This patch still has the same problems as before.
>
> regards,
> dan carpenter
>
>
Should I remove
#ifdef WILC_SPI
      struct wilc *wilc;
 #endif

? Built is successful
