Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:32797 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0ALWvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 17:51:08 -0500
Received: by ewy1 with SMTP id 1so5319108ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 14:51:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001122310.21654.mb@bu3sch.de>
References: <op.u6fp5shd9lhzdc@linux-g0th.site>
	 <201001122310.21654.mb@bu3sch.de>
Date: Tue, 12 Jan 2010 23:51:06 +0100
Message-ID: <b170af451001121451p73941b5ema0fb9be8685335ae@mail.gmail.com>
Subject: Re: [PATCH 1/3] b43: N-PHY: add b43_nphy_rx_iq_est and
	b43_nphy_tx_iq_workaround
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/12 Michael Buesch <mb@bu3sch.de>:
> On Tuesday 12 January 2010 20:38:07 Rafał Miłecki wrote:
>>   struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
>> +struct nphy_iq_est { s32 iq0_prod; u32 i0_pwr; u32 q0_pwr; s32 iq1_prod;
>> +                     u32 i1_pwr; u32 q1_pwr; };
>
> So it seems I didn't notice this earlier, but this violates kernel coding style.
> Please do a separate patch that converts all structs from
> struct foo { a; b; c; };
> to
> struct foo {
>        a;
>        b;
>        c;
> };

OK, will do.


>> +     if (wait)
>> +             b43_phy_set(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_MODE);
>> +     else
>> +             b43_phy_mask(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_MODE);
>
> Looks wrong to me.
> Do you want this?
>
> +       if (wait)
> +               b43_phy_set(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_MODE);
> +       else
> +               b43_phy_mask(dev, B43_NPHY_IQEST_CMD, ~B43_NPHY_IQEST_CMD_MODE);

Obviously. Copy&paste... I can changed function name. Thanks for catching :)


>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxIqWar */
>> +static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
>> +{
>> +     u16 array[4];
>> +     int i;
>> +
>> +     b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C50);
>> +     for (i = 0; i < 4; i++)
>> +             array[i] = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
>> +
>> +     b43_shm_write16(dev, B43_SHM_SHARED, 0x0700, array[0]);
>> +     b43_shm_write16(dev, B43_SHM_SHARED, 0x0702, array[1]);
>> +     b43_shm_write16(dev, B43_SHM_SHARED, 0x0704, array[2]);
>> +     b43_shm_write16(dev, B43_SHM_SHARED, 0x0706, array[3]);
>
> Do we have some names for the SHM locations?
> If not, just do some defines.
> #define B43_SHM_SH_NPHY_TXIQW0  0x0700
> #define B43_SHM_SH_NPHY_TXIQW1  0x0702
> ...
> in b43.h (next to the other SHM_SH defines)

Larry, do you have any other/better names?


-- 
Rafał
