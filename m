Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61739 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0AKW1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:27:19 -0500
Received: by ewy1 with SMTP id 1so3810395ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 14:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001112313.26197.mb@bu3sch.de>
References: <op.u6b70wtk9lhzdc@linux-g0th.site>
	 <201001102338.28721.mb@bu3sch.de>
	 <b170af451001111313r6bc6905fg722fcd42d7f2681a@mail.gmail.com>
	 <201001112313.26197.mb@bu3sch.de>
Date: Mon, 11 Jan 2010 23:27:18 +0100
Message-ID: <b170af451001111427u25861f2bla4062a7b0aea19ec@mail.gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 stycznia 2010 23:13 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> On Monday 11 January 2010 22:13:31 Rafał Miłecki wrote:
>> 2010/1/10 Michael Buesch <mb@bu3sch.de>:
>> > On Sunday 10 January 2010 23:13:34 Rafał Miłecki wrote:
>> >> +     s32 results_min[4];
>> >> +     u8 vcm_final[4];
>> >> +     s32 results[4][4];
>> >> +     s32 miniq[4][2];
>> >> +     memset(results_min, 0, sizeof(s32) * 4);
>> >> +     memset(vcm_final, 0, sizeof(u8) * 4);
>> >> +     memset(results, 0, sizeof(s32) * 4 * 4);
>> >> +     memset(miniq, 0, sizeof(s32) * 4 * 2);
>> >
>> > Just initialize the variables to zero instead of doing a memset:
>> >
>> > +       s32 results_min[4] = { 0, };
>> > +       u8 vcm_final[4] = { 0, };
>> > +       s32 results[4][4] = { 0, };
>> > +       s32 miniq[4][2] = { 0, };
>>
>> Nice trick, thanks :) Just for two-dimensional arrays I'll have to hack it to:
>> s32 results[4][4] = { { 0, }, { 0, }, { 0, }, { 0, } };
>> I believe.
>
> No I don't think so.
> It's C standard that uninitialized elements on automatic variables are initialized
> to zero, _if_ at least one element is initialized to something.
> So if you init one element to 0, all others will be 0, too.
> I think that should also work for multidimensional arrays. So my example
> s32 results[4][4] = { 0, };
> should do the right thing. Am I wrong?

Whoops, I should have explained what I mean. I am not sure what CFLAGS
"make" picks for compiled but I get:

  CC [M]  drivers/net/wireless/b43/phy_n.o
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_rev2_rssi_cal’:
drivers/net/wireless/b43/phy_n.c:887: warning: missing braces around initializer
drivers/net/wireless/b43/phy_n.c:887: warning: (near initialization
for ‘results[0]’)

for s32 results[4][4] = { 0, };

-- 
Rafał
