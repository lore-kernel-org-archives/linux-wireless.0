Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47781 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaETHJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:09:50 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so58081obc.25
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <537AFAA0.3070401@meshcoding.com>
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
	<537AFAA0.3070401@meshcoding.com>
Date: Tue, 20 May 2014 09:09:49 +0200
Message-ID: <CACna6rwa6zKX=ngSQhmWTrZcy_W7fjMrTmQ-A8XURZCVMX1nrA@mail.gmail.com> (sfid-20140520_090953_205295_3B2467A4)
Subject: Re: [PATCH] b43: xmit: set 5 GHz bit depending on current band
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2014 08:48, Antonio Quartulli <antonio@meshcoding.com> wrote:
> On 20/05/14 08:46, Rafał Miłecki wrote:
>> --- a/drivers/net/wireless/b43/xmit.c
>> +++ b/drivers/net/wireless/b43/xmit.c
>> -     if (phy->type == B43_PHYTYPE_A)
>> +     if (!phy->gmode)
>>               mac_ctl |= B43_TXH_MAC_5GHZ;
>
> I am not familiar with this driver, but wouldn't 11b mode fall in this
> case as well ?

What Broadcom calls a "gmode" is 2GHz. So this is a simple bool
1) gmode = true; // we work in 2GHz mode
2) gmode = false; // we work in 5GHz mode
