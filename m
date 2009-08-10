Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:22952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZHJLhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 07:37:53 -0400
Received: by fg-out-1718.google.com with SMTP id e12so421222fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 04:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7F811F.4070908@lwfinger.net>
References: <4A7F713E.8040405@gmail.com> <4A7F811F.4070908@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 10 Aug 2009 13:37:34 +0200
Message-ID: <69e28c910908100437n46a04f76tf91876d48ab19cb4@mail.gmail.com>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/10 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> Implement LP-PHY baseband table init for all revisions.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>>
>> ---
>> Sorry for the size; it's difficult to cut short changes like this
>> (most of the patch is just table data). Please review, there may always be
>> bugs that I failed to catch while reading through the code. I have added
>> comments to places that were not quite clear to me.
>>
>> phy_lp.c       |   41 tables_lpphy.c | 3223
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> tables_lpphy.h |    3 3 files changed, 3263 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_lp.c
>> b/drivers/net/wireless/b43/phy_lp.c
>> index 27eadee..cf17489 100644
>> --- a/drivers/net/wireless/b43/phy_lp.c
>> +++ b/drivers/net/wireless/b43/phy_lp.c
>> @@ -59,9 +59,43 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
>>     dev->phy.lp = NULL;
>> }
>>
>> +static void lpphy_adjust_gain_table(struct b43_wldev *dev)
>> +{
>> +    struct b43_phy_lp *lpphy = dev->phy.lp;
>> +    u32 freq = dev->wl->hw->conf.channel->center_freq;
>> +    u16 temp[3];
>> +    u16 isolation;
>> +
>> +    B43_WARN_ON(dev->phy.rev >= 2);
>> +
>> +    if (freq < 2400) /* FIXME Can this ever happen? Should we WARN_ON? */
>
> This was a typo. It should be 2500, not 2400.

Thanks! So it is actually better to implement this as "if
(b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)"? That would make
it easier to implement non-standard channels similar to how it was
done for ath5k (Richard Farina's frequency patch - assuming the HW is
capable of something like that).

>
>> +        isolation = lpphy->tx_isolation_med_band;
>> +    else if (freq <= 5320)
>
> --snip --
>
>> +void lpphy_rev2plus_table_init(struct b43_wldev *dev)
>> +{
>> +    struct ssb_bus *bus = dev->dev->bus;
>> +    int i;
>> +
>> +    B43_WARN_ON(dev->phy.rev < 2);
>> +
>> +    //XXX should this be done using b43_lptab_write_bulk?
>> +    for (i = 0; i < 704; i++)
>> +        b43_lptab_write(dev, B43_LPTAB32(7, i), 0);
>
> No. The bulk write is for writing tables with length greater than 1.
> In this case, you have 704 different tables each of length 1.

By the way, looking at the implementation again, it looks a bit fishy
to me - we write zeros to 4 bytes of table ID 7, then increase the
offset by 1 byte, and again write 4 bytes - 3 of which are the same
bytes we already zeroed in the previous step.

I suspect this would suffice:

for (i = 0; i < 704; i += 4)
           b43_lptab_write(dev, B43_LPTAB32(7, i), 0);

This version cuts the write count in half, and removes redundant byte writes.

Maybe this should be tested once the code is functional.

>
> I am still looking through the patch. I'll let you know of any thing I
> find.
>
> Larry
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
