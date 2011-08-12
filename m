Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64744 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HLPQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 11:16:41 -0400
Received: by yie30 with SMTP id 30so2015019yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 08:16:41 -0700 (PDT)
Message-ID: <4E4543D5.9070006@lwfinger.net> (sfid-20110812_171644_930381_54EB5B60)
Date: Fri, 12 Aug 2011 10:16:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH V2 4/4] b43: HT-PHY: init: init BPHY and upload 0x1a table
References: <1313155654-8988-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1313155654-8988-4-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 08:27 AM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> BPHY is something partially known from N-PHY.
>
> This 0x1a table with 0xc0 offset is a little tricky. We already upload
> something like that earlier, but this is needed to stop radio going crazy
> and transmissint crap.

I don't care that the commit message contains "crap", but others might. I do, 
however, want you to change from the nonexistent "transmissint" to 
"transmission" or "transmitting", whichever you mean.

Other than that, ACK. Note, I have no HT device, thus I have done no testing.

Larry


>
> V2: limit line to 80 chars
> ---
>   drivers/net/wireless/b43/phy_ht.c        |   26 ++++++++++++++++++++
>   drivers/net/wireless/b43/tables_phy_ht.c |   39 ++++++++++++++++++++++++++++++
>   drivers/net/wireless/b43/tables_phy_ht.h |    3 ++
>   3 files changed, 68 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
> index 2ea7b08..84811b0 100644
> --- a/drivers/net/wireless/b43/phy_ht.c
> +++ b/drivers/net/wireless/b43/phy_ht.c
> @@ -169,6 +169,24 @@ static void b43_phy_ht_zero_extg(struct b43_wldev *dev)
>   		b43_phy_write(dev, B43_PHY_EXTG(base[i] + 0xc), 0);
>   }
>
> +static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
> +{
> +	unsigned int i;
> +	u16 val;
> +
> +	val = 0x1E1F;
> +	for (i = 0; i<  16; i++) {
> +		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
> +		val -= 0x202;
> +	}
> +	val = 0x3E3F;
> +	for (i = 0; i<  16; i++) {
> +		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
> +		val -= 0x202;
> +	}
> +	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
> +}
> +
>   /**************************************************
>    * Channel switching ops.
>    **************************************************/
> @@ -322,6 +340,14 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
>
>   	b43_mac_phy_clock_set(dev, true);
>
> +	/* TODO: Some ops here */
> +
> +	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
> +		b43_phy_ht_bphy_init(dev);
> +
> +	b43_httab_write_bulk(dev, B43_HTTAB32(0x1a, 0xc0),
> +			B43_HTTAB_1A_C0_LATE_SIZE, b43_httab_0x1a_0xc0_late);
> +
>   	return 0;
>   }
>
> diff --git a/drivers/net/wireless/b43/tables_phy_ht.c b/drivers/net/wireless/b43/tables_phy_ht.c
> index 9681af5..677d217 100644
> --- a/drivers/net/wireless/b43/tables_phy_ht.c
> +++ b/drivers/net/wireless/b43/tables_phy_ht.c
> @@ -574,6 +574,42 @@ static const u32 b43_httab_0x24[] = {
>   	0x005d0582, 0x005805d6, 0x0053062e, 0x004e068c,
>   };
>
> +/* Some late-init table */
> +const u32 b43_httab_0x1a_0xc0_late[] = {
> +	0x10f90040, 0x10e10040, 0x10e1003c, 0x10c9003d,
> +	0x10b9003c, 0x10a9003d, 0x10a1003c, 0x1099003b,
> +	0x1091003b, 0x1089003a, 0x1081003a, 0x10790039,
> +	0x10710039, 0x1069003a, 0x1061003b, 0x1059003d,
> +	0x1051003f, 0x10490042, 0x1049003e, 0x1049003b,
> +	0x1041003e, 0x1041003b, 0x1039003e, 0x1039003b,
> +	0x10390038, 0x10390035, 0x1031003a, 0x10310036,
> +	0x10310033, 0x1029003a, 0x10290037, 0x10290034,
> +	0x10290031, 0x10210039, 0x10210036, 0x10210033,
> +	0x10210030, 0x1019003c, 0x10190039, 0x10190036,
> +	0x10190033, 0x10190030, 0x1019002d, 0x1019002b,
> +	0x10190028, 0x1011003a, 0x10110036, 0x10110033,
> +	0x10110030, 0x1011002e, 0x1011002b, 0x10110029,
> +	0x10110027, 0x10110024, 0x10110022, 0x10110020,
> +	0x1011001f, 0x1011001d, 0x1009003a, 0x10090037,
> +	0x10090034, 0x10090031, 0x1009002e, 0x1009002c,
> +	0x10090029, 0x10090027, 0x10090025, 0x10090023,
> +	0x10090021, 0x1009001f, 0x1009001d, 0x1009001b,
> +	0x1009001a, 0x10090018, 0x10090017, 0x10090016,
> +	0x10090015, 0x10090013, 0x10090012, 0x10090011,
> +	0x10090010, 0x1009000f, 0x1009000f, 0x1009000e,
> +	0x1009000d, 0x1009000c, 0x1009000c, 0x1009000b,
> +	0x1009000a, 0x1009000a, 0x10090009, 0x10090009,
> +	0x10090008, 0x10090008, 0x10090007, 0x10090007,
> +	0x10090007, 0x10090006, 0x10090006, 0x10090005,
> +	0x10090005, 0x10090005, 0x10090005, 0x10090004,
> +	0x10090004, 0x10090004, 0x10090004, 0x10090003,
> +	0x10090003, 0x10090003, 0x10090003, 0x10090003,
> +	0x10090003, 0x10090002, 0x10090002, 0x10090002,
> +	0x10090002, 0x10090002, 0x10090002, 0x10090002,
> +	0x10090002, 0x10090002, 0x10090001, 0x10090001,
> +	0x10090001, 0x10090001, 0x10090001, 0x10090001,
> +};
> +
>   /**************************************************
>    * R/W ops.
>    **************************************************/
> @@ -768,6 +804,9 @@ void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
>   	} while (0)
>   void b43_phy_ht_tables_init(struct b43_wldev *dev)
>   {
> +	BUILD_BUG_ON(ARRAY_SIZE(b43_httab_0x1a_0xc0_late) !=
> +			B43_HTTAB_1A_C0_LATE_SIZE);
> +
>   	httab_upload(dev, B43_HTTAB16(0x12, 0), b43_httab_0x12);
>   	httab_upload(dev, B43_HTTAB16(0x27, 0), b43_httab_0x27);
>   	httab_upload(dev, B43_HTTAB16(0x26, 0), b43_httab_0x26);
> diff --git a/drivers/net/wireless/b43/tables_phy_ht.h b/drivers/net/wireless/b43/tables_phy_ht.h
> index c68b0fa..1b5ef2b 100644
> --- a/drivers/net/wireless/b43/tables_phy_ht.h
> +++ b/drivers/net/wireless/b43/tables_phy_ht.h
> @@ -20,4 +20,7 @@ void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
>
>   void b43_phy_ht_tables_init(struct b43_wldev *dev);
>
> +#define B43_HTTAB_1A_C0_LATE_SIZE		128
> +extern const u32 b43_httab_0x1a_0xc0_late[];
> +
>   #endif /* B43_TABLES_PHY_HT_H_ */

