Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46943 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZKZXkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 18:40:21 -0500
Received: by ewy19 with SMTP id 19so945715ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 15:40:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911260851.00192.holgerschurig@gmail.com>
References: <200911250941.10929.holgerschurig@gmail.com>
	 <43e72e890911250736l33afdf8ak1c806e5f5482f9da@mail.gmail.com>
	 <200911260851.00192.holgerschurig@gmail.com>
Date: Fri, 27 Nov 2009 01:40:26 +0200
Message-ID: <40f31dec0911261540i2abf7023u225b87ff5e177b96@mail.gmail.com>
Subject: Re: PROPOSAL: cfg80211 antenna selection
From: Nick Kossifidis <mickflemm@gmail.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/26 Holger Schurig <holgerschurig@gmail.com>:
>> While at it might as well make this some configurable struct
>> which the drivers can add to the wiphy just as with the
>> subbands.
>
> Something like this?
>
>
> struct ieee80211_antenna lbs_antennas {
>        u32 hwvalue;
>        u32 flags;
>        u32 capability;
>        int max_gain;
> }
>
> static struct ieee80211_antenna lbs_antennas[] = {
>        {
>                .hwvalue = 0,
>                .capability = IEEE80211_ANTENNA_RXTX,
>        }
> };
>
> wiphy->antennas = lbs_antennas;
> wiphy->n_anteanns = ARRAY_SIZE(lbs_antennas);
>
> Or should the antennas be added to "struct
> ieee80211_supported_band" instead of wiphy?
>
>
> Capabilities could be
>
> #define IEEE80211_ANTENNA_RX         BIT(0)
> #define IEEE80211_ANTENNA_TX         BIT(1)
> #define IEEE80211_ANTENNA_OMNI       BIT(2)
> #define IEEE80211_ANTENNA_SECTIONAL  BIT(3)
> #define IEEE80211_ANTENNA_RXTX
>   (IEEE80211_ANTENNA_RX | IEEE80211_ANTENNA_TX)
>
> An unknown gain would be set to 0.
>
>
>
>> Not sure how to get this from other cards. Anyone know how
>> about on b43, iwlwifi, rallink?
>
> Libertas doesn't give this to you, AFAIK you can just get the
> number of antennas.
>
>
>> Not sure if allowing for ops for chainmask setting would also
>> be helpeful here, that would need some review.
>
> What is "chainmask setting", I don't even know the concept.
>
>
>
> You didn't give any comment on my mask idea for the user-space
> API.
>


This is what we have on ath5k right now...

enum ath5k_ant_mode {
        AR5K_ANTMODE_DEFAULT    = 0,    /* default antenna setup */
        AR5K_ANTMODE_FIXED_A    = 1,    /* only antenna A is present */
        AR5K_ANTMODE_FIXED_B    = 2,    /* only antenna B is present */
        AR5K_ANTMODE_SINGLE_AP  = 3,    /* sta locked on a single ap */
        AR5K_ANTMODE_SECTOR_AP  = 4,    /* AP with tx antenna set on tx desc */
        AR5K_ANTMODE_SECTOR_STA = 5,    /* STA with tx antenna set on tx desc */
        AR5K_ANTMODE_DEBUG      = 6,    /* Debug mode -A -> Rx, B-> Tx- */
        AR5K_ANTMODE_MAX,
};

...think more like antenna setups or scenarios.

#define IEEE80211_ANTENNA_RX         BIT(0)

Also i suggest that we don't use IEEE80211_* for non 80211 related stuff...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
