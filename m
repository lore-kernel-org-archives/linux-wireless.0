Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57173 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0AKVNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 16:13:36 -0500
Received: by ewy1 with SMTP id 1so3718391ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 13:13:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001102338.28721.mb@bu3sch.de>
References: <op.u6b70wtk9lhzdc@linux-g0th.site>
	 <201001102338.28721.mb@bu3sch.de>
Date: Mon, 11 Jan 2010 22:13:31 +0100
Message-ID: <b170af451001111313r6bc6905fg722fcd42d7f2681a@mail.gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/10 Michael Buesch <mb@bu3sch.de>:
> On Sunday 10 January 2010 23:13:34 Rafał Miłecki wrote:
>> +     s32 results_min[4];
>> +     u8 vcm_final[4];
>> +     s32 results[4][4];
>> +     s32 miniq[4][2];
>> +     memset(results_min, 0, sizeof(s32) * 4);
>> +     memset(vcm_final, 0, sizeof(u8) * 4);
>> +     memset(results, 0, sizeof(s32) * 4 * 4);
>> +     memset(miniq, 0, sizeof(s32) * 4 * 2);
>
> Just initialize the variables to zero instead of doing a memset:
>
> +       s32 results_min[4] = { 0, };
> +       u8 vcm_final[4] = { 0, };
> +       s32 results[4][4] = { 0, };
> +       s32 miniq[4][2] = { 0, };

Nice trick, thanks :) Just for two-dimensional arrays I'll have to hack it to:
s32 results[4][4] = { { 0, }, { 0, }, { 0, }, { 0, } };
I believe.


>> +     b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, 0);
>> +     b43_radio_maskset(dev, B2055_C2_PD_RSSIMISC, 0xF8, 0);
>
> If you don't set anything, you can use
> b43_radio_mask();

Sure I can ;) Thanks.

-- 
Rafał
