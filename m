Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63553 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZI1TpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 15:45:25 -0400
Received: by bwz6 with SMTP id 6so1526081bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 12:45:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090928184111.GB4737@tuxdriver.com>
References: <200909032025.31260.chunkeey@googlemail.com>
	 <20090918170211.8acce2cc.akpm@linux-foundation.org>
	 <4AB4CCD0.5080003@gmx.de> <20090928184111.GB4737@tuxdriver.com>
Date: Mon, 28 Sep 2009 21:45:28 +0200
Message-ID: <22ee4e770909281245g3346a800n940c28199e429abf@mail.gmail.com>
Subject: Re: [PATCH] ar9170: implement frequency calibration for
	one-stage/openfw
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Joerg Albert <jal2@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/28 John W. Linville <linville@tuxdriver.com>:
> On Sat, Sep 19, 2009 at 02:21:36PM +0200, Joerg Albert wrote:
>> On 09/19/2009 02:02 AM, Andrew Morton wrote:
>> > On Thu, 3 Sep 2009 20:25:31 +0200
>> > Christian Lamparter <chunkeey@googlemail.com> wrote:
>> >
>> >> This patch ports some code from the vendor driver, which is
>> >> supposed to upload the right calibration values for the
>> >> chosen frequency.
>> >>
>> >> In theory, this should give a better range and throughput
>> >> for all users with the open, or one-stage firmware.
>> >>
>> >> ...
>> >>
>> >> +          for (i = 0; i < 76; i++) {
>> >> +                  u32 phy_data;
>> >> +                  u8 tmp;
>> >> +
>> >> +                  if (i < 25) {
>> >> +                          tmp = ar9170_interpolate_val(i, &pwrs[0][0],
>> >> +                                                       &vpds[0][0]);
>> >> +                  } else {
>> >> +                          tmp = ar9170_interpolate_val(i - 12,
>> >> +                                                       &pwrs[1][0],
>> >> +                                                       &vpds[1][0]);
>> >> +                  }
>> >> +
>> >> +                  phy_data |= tmp << ((i & 3) << 3);
>> >
>> > Clearly buggy and the compiler warns.  The value of phy_data is unknown
>> > here.
>> >
>> > How did this get all the way into mainline?
>>
>> Strangely it compiles without any warning for me with the latest linux-wireless:
>
> That is strange -- no warning here (F-11) either...
>
> Christian, care to propose a patch?  Or maybe just something like this?
>
> diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> index b3e5cf3..49c10cb 100644
> --- a/drivers/net/wireless/ath/ar9170/phy.c
> +++ b/drivers/net/wireless/ath/ar9170/phy.c
> @@ -1220,7 +1220,7 @@ static int ar9170_set_freq_cal_data(struct ar9170 *ar,
>                                                             &vpds[1][0]);
>                        }
>
> -                       phy_data |= tmp << ((i & 3) << 3);
> +                       phy_data = tmp << ((i & 3) << 3);
>                        if ((i & 3) == 3) {
>                                ar9170_regwrite(0x1c6280 + chain * 0x1000 +
>                                                (i & ~3), phy_data);
>
> John
no? Andrew Morton's mail included a tiny patch which initializes the
phy_data to 0. I assumed you would pick it up right away...
Or is there something which would prevent it from including?

Regards,
         Chr
