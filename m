Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41307 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab2BWV1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 16:27:47 -0500
Message-ID: <4F46AF41.6060803@hauke-m.de> (sfid-20120223_222800_256848_17D4E099)
Date: Thu, 23 Feb 2012 22:27:29 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch
Subject: Re: [PATCH 01/11] ssb: sprom fix some sizes / signedness
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de> <1329676345-15856-2-git-send-email-hauke@hauke-m.de> <CACna6rwNEPY3iJCeWV3AmbBy7fQwQrgr9Oji6tro-Dr23y5udQ@mail.gmail.com>
In-Reply-To: <CACna6rwNEPY3iJCeWV3AmbBy7fQwQrgr9Oji6tro-Dr23y5udQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 07:14 PM, Rafał Miłecki wrote:
> 2012/2/19 Hauke Mehrtens <hauke@hauke-m.de>:
>> @@ -53,10 +53,10 @@ struct ssb_sprom {
>>        u8 gpio1;               /* GPIO pin 1 */
>>        u8 gpio2;               /* GPIO pin 2 */
>>        u8 gpio3;               /* GPIO pin 3 */
>> -       u16 maxpwr_bg;          /* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
>> -       u16 maxpwr_al;          /* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
>> -       u16 maxpwr_a;           /* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
>> -       u16 maxpwr_ah;          /* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
>> +       u8 maxpwr_bg;           /* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
>> +       u8 maxpwr_al;           /* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
>> +       u8 maxpwr_a;            /* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
>> +       u8 maxpwr_ah;           /* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
>>        u8 itssi_a;             /* Idle TSSI Target for A-PHY */
>>        u8 itssi_bg;            /* Idle TSSI Target for B/G-PHY */
>>        u8 tri2g;               /* 2.4GHz TX isolation */
> 
> Just a note in case you're going to develop ssb/bcma/b43/brcm code.
> Please note we're trying to switch from properties you modified to
> struct ssb_sprom_core_pwr_info.
These vars are available in sprom 1-3,8,9 and the ones in struct
ssb_sprom_core_pwr_info just for sprom 4,5,8,9. The old are probably not
used by newer chips any more. I just found these because I generated my
parsing code from broadcom open source code and got a compiler warning
because of wrong sizes.
> 
> The patch still looks fine.
> 

