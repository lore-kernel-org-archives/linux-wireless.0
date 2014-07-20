Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44428 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGTLeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:34:23 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so5923698oag.13
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:34:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140720131937.3229b17c@wiggum>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
	<20140720131937.3229b17c@wiggum>
Date: Sun, 20 Jul 2014 13:34:23 +0200
Message-ID: <CACna6rySBXCzOhPTEd1Q4RsdQ0XBJSc0X3e2y5mH7O4c7kg5LA@mail.gmail.com> (sfid-20140720_133429_061648_A54DF3E1)
Subject: Re: [PATCH 1/2] b43: implement PPR (Power Per Rate) management/API
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2014 13:19, Michael Büsch <m@bues.ch> wrote:
> On Sun, 20 Jul 2014 13:00:21 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> +#define B43_PPR_CCK_RATES_NUM                4
>> +#define B43_PPR_OFDM_RATES_NUM               8
>> +#define B43_PPR_MCS_RATES_NUM                8
>> +
>> +#define B43_PPR_RATES_NUM    (B43_PPR_CCK_RATES_NUM +        \
>> +                              B43_PPR_OFDM_RATES_NUM * 2 +   \
>> +                              B43_PPR_MCS_RATES_NUM * 4)
>> +
>> +struct b43_ppr_rates {
>> +     u8 cck[B43_PPR_CCK_RATES_NUM];
>> +     u8 ofdm[B43_PPR_OFDM_RATES_NUM];
>> +     u8 ofdm_20_cdd[B43_PPR_OFDM_RATES_NUM];
>> +     u8 mcs_20[B43_PPR_MCS_RATES_NUM]; /* SISO */
>> +     u8 mcs_20_cdd[B43_PPR_MCS_RATES_NUM];
>> +     u8 mcs_20_stbc[B43_PPR_MCS_RATES_NUM];
>> +     u8 mcs_20_sdm[B43_PPR_MCS_RATES_NUM];
>> +} __packed;
>> +
>> +struct b43_ppr {
>> +     /* All powers are in qdbm (Q5.2) */
>> +     union {
>> +             u8 __all_rates[B43_PPR_RATES_NUM];
>> +             struct b43_ppr_rates rates;
>> +     } __packed;
>
> I don't think this union has to be packed.
> And most likely struct b43_ppr_rates is ok without packing, too.
> You could probably remove it there and add a BUILD_BUG which checks something like (pseudocode):
> BUILD_BUG_ON(offsetof(struct b43_ppr_rates.mcs_20_sdm) != B43_PPR_CCK_RATES_NUM + B43_PPR_OFDM_RATES_NUM * 2 + B43_PPR_MCS_RATES_NUM * 3);
>
> Removing packed will produce much nicer code.

Thanks for your comments. I'll rework this.
John: please wait for V2

Btw. I was waiting for comments since Monday you slug (just kidding!) ;)

-- 
Rafał
