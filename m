Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:39823 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGUH4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 03:56:49 -0400
Received: by mail-qa0-f50.google.com with SMTP id s7so4801770qap.23
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 00:56:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F7043122FE2C62A@SC-VEXCH1.marvell.com>
References: <1405670437-18723-1-git-send-email-afenkart@gmail.com>
	<20140718175915.GG31114@tuxdriver.com>
	<477F20668A386D41ADCC57781B1F7043122FE2C62A@SC-VEXCH1.marvell.com>
Date: Mon, 21 Jul 2014 09:56:49 +0200
Message-ID: <CALtMJEAwvMrZcFW7+ACgDNRVi+O5LE0p8gRUTUN3pNh8N1Eiog@mail.gmail.com> (sfid-20140721_095654_407009_73AAB309)
Subject: Re: [PATCH] mwifiex: card reset: enable rescan of non-removable card
From: Andreas Fenkart <afenkart@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2014-07-18 21:07 GMT+02:00 Bing Zhao <bzhao@marvell.com>:
>> > @@ -1931,6 +1931,7 @@ static void sdio_card_reset_worker(struct work_struct *work)
>> >     mmc_remove_host(target);
>> >     /* 20ms delay is based on experiment with sdhci controller */
>> >     mdelay(20);
>> > +   reset_host->rescan_entered = 0; /* rescan non-removable cards */

I used the global the variable,
static struct mmc_host *reset_host;

>
> You meant this?
>
> +       target->rescan_entered = 0; /* rescan non-removable cards */

of course, should be the local variable, sending out new patch.

v2
- replaced global variable by local 'target' variable

>
> Regards,
> Bing
>
>> >     mmc_add_host(target);
>> >  }
>> >  static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
>>
>> Building wireless-next:
>>
>>   CC      drivers/net/wireless/mwifiex/sdio.o
>> drivers/net/wireless/mwifiex/sdio.c: In function ‘mwifiex_sdio_card_reset_work’:
>> drivers/net/wireless/mwifiex/sdio.c:1957:2: error: ‘reset_host’ undeclared (first use in this
>> function)
>>   reset_host->rescan_entered = 0; /* rescan non-removable cards */
>>   ^
>> drivers/net/wireless/mwifiex/sdio.c:1957:2: note: each undeclared identifier is reported only once
>> for each function it appears in
>
>
>
