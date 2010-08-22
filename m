Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41446 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0HVUAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 16:00:08 -0400
Received: by qwh6 with SMTP id 6so4575678qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 13:00:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikP5hQKMyJD1-7+gaY8PykQ77At+Vpkqf=HRT0H@mail.gmail.com>
References: <1282506452-8159-1-git-send-email-zajec5@gmail.com>
	<AANLkTikP5hQKMyJD1-7+gaY8PykQ77At+Vpkqf=HRT0H@mail.gmail.com>
Date: Sun, 22 Aug 2010 22:00:07 +0200
Message-ID: <AANLkTincNmC+Lbm_UbzARx6LiHinOnQMF=vb6PKfp66x@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: add missing phyrxchain setting and fix
 warning in RX core function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 sierpnia 2010 21:49 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/8/22 Rafał Miłecki <zajec5@gmail.com>:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> Gábor: please kindly, watch out for such a missing calls/sets. We may lose a
>> lot of time looking for such a missing lines later.
>> ---
>>  drivers/net/wireless/b43/phy_n.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>> index d116229..2466c0a 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -3092,6 +3092,8 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
>>        struct b43_phy_n *nphy = phy->n;
>>        u16 buf[16];
>>
>> +       nphy->phyrxchain = mask;
>> +
>>        if (0 /* FIXME clk */)
>>                return;
>>
>> @@ -3103,7 +3105,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
>>        b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
>>                        (mask & 0x3) << B43_NPHY_RFSEQCA_RXEN_SHIFT);
>>
>> -       if (mask & 0x3 != 0x3) {
>> +       if ((mask & 0x3) != 0x3) {
>
> Why is this needed? An & doesn't magically transform into an && under
> any circumstances...

I agree it's quite obvious, however I believe kernel compiles with
flags raising such a warnings by default:

drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_set_rx_core_state’:
drivers/net/wireless/b43/phy_n.c:3106:2: warning: suggest parentheses
around comparison in operand of ‘&’

-- 
Rafał
