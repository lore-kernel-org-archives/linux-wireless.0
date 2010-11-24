Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64000 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab0KXAfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 19:35:08 -0500
Received: by qyk11 with SMTP id 11so3020011qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 16:35:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimnRS1Mh4KtjFNJOcUEb-JNDs+B8vqFbkh-EybL@mail.gmail.com>
References: <20101123190911.GN4303@makis.mantri> <AANLkTimnRS1Mh4KtjFNJOcUEb-JNDs+B8vqFbkh-EybL@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 24 Nov 2010 10:34:50 +1000
Message-ID: <AANLkTinjCYuPz8YyYw6XPKvqvyYm1LUZeazEy-uXVRik@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 14/30] ath5k: Extend get_default_sifs/slot_time
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 10:31 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> On Wed, Nov 24, 2010 at 5:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>>  * Extend get_default_sifs/slot_time to include timings for turbo
>>  half and quarter rate modes.
>>
>>  * AR5210 code for now uses timings already on core clock units
>>  instead of usecs so rename them (we 'll clean it up later).
>>
>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath5k/ath5k.h |   24 ++++++++++++--
>>  drivers/net/wireless/ath/ath5k/pcu.c   |   52 ++++++++++++++++++++++++--------
>>  drivers/net/wireless/ath/ath5k/qcu.c   |   16 +++++----
>>  3 files changed, 68 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
>> index 005cad0..e11fc8f 100644
>> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
>> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
>> @@ -226,16 +226,16 @@
>>  #define AR5K_INIT_USEC                         39
>>  #define AR5K_INIT_USEC_TURBO                   79
>>  #define AR5K_INIT_USEC_32                      31
>> -#define AR5K_INIT_SLOT_TIME                    396
>> -#define AR5K_INIT_SLOT_TIME_TURBO              480
>> +#define AR5K_INIT_SLOT_TIME_CLOCK              396
>
> This comes out as 9.9us (with a clock multiplier of 40), rather than 9
> - should be 360?
>
>> +#define AR5K_INIT_SLOT_TIME_TURBO_CLOCK                480
>>  #define AR5K_INIT_ACK_CTS_TIMEOUT              1024
>
> From a previous post I'd made:
>
> According to the 802.11-2007 spec document, the ACKTimeout value is
> (Section 9.2.8 ACK procedure):
> ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay
>
> From Table 17-15—OFDM PHY characteristics, the values are:
> aSIFSTime = 16
> aSlotTime = 9
> aPHY-RX-START-Delay = 25
>
> Therefore, ACKTimeout = 50
>
> With a value of 1024, the ACKTIMEOUT is actually 25.
>
>>  #define AR5K_INIT_ACK_CTS_TIMEOUT_TURBO                0x08000800
>>  #define AR5K_INIT_PROG_IFS                     920
>>  #define AR5K_INIT_PROG_IFS_TURBO               960
>>  #define AR5K_INIT_EIFS                         3440
>
> From the 802.11-2007 Spec (9.2.10 DCF timing relations):
> The EIFS is derived from the SIFS and the DIFS and the length of time
> it takes to transmit an ACK Control frame at the lowest PHY mandatory
> rate by the following equation:
> EIFS = aSIFSTime + DIFS + ACKTxTime
> where ACKTxTime is the time expressed in microseconds required to
> transmit an ACK frame, including
> preamble, PLCP header and any additional PHY dependent information, at
> the lowest PHY mandatory rate.
>
> So, EIFS = 16 + 32 + 44 (ACKTX @ 24Mbps) = 92
> or 16 + 32 + 60 (ACKTX @ 6Mbps) = 108
>
> The current value is 86, which I guess is a nice midpoint, but is
> there any reasoning for this value? It should really be set to the
> longest value of 108, as an EIFS is only used when we have no
> information about a frame because it failed the checksum.
>
>>  #define AR5K_INIT_EIFS_TURBO                   6880
>> -#define AR5K_INIT_SIFS                         560
>> -#define AR5K_INIT_SIFS_TURBO                   480
>> +#define AR5K_INIT_SIFS_CLOCK                   560
>
> This is wrong, when you divide by the clock rate, you get a SIFS of 14, not 16.
>
> Cheers,
>
> Jonathan

Just as an aside, I didn't mean to hijack Nick's patches for this, but
these are some things that I've been discussing with Bruno. I'm happy
to provide a separate patch to remedy these if required.

Cheers,

Jonathan

>
>> +#define AR5K_INIT_SIFS_TURBO_CLOCK             480
>>  #define AR5K_INIT_SH_RETRY                     10
>>  #define AR5K_INIT_LG_RETRY                     AR5K_INIT_SH_RETRY
>>  #define AR5K_INIT_SSH_RETRY                    32
>> @@ -251,6 +251,22 @@
>>        (AR5K_INIT_PROG_IFS_TURBO)                                      \
>>  )
>>
>> +/* Slot time */
>> +#define AR5K_INIT_SLOT_TIME_TURBO              6
>> +#define AR5K_INIT_SLOT_TIME_DEFAULT            9
>> +#define        AR5K_INIT_SLOT_TIME_HALF_RATE           13
>> +#define        AR5K_INIT_SLOT_TIME_QUARTER_RATE        21
>> +#define        AR5K_INIT_SLOT_TIME_B                   20
>> +#define AR5K_SLOT_TIME_MAX                     0xffff
>> +
>> +/* SIFS */
>> +#define        AR5K_INIT_SIFS_TURBO                    6
>> +/* XXX: 8 from initvals 10 from standard */
>> +#define        AR5K_INIT_SIFS_DEFAULT_BG               8
>> +#define        AR5K_INIT_SIFS_DEFAULT_A                16
>> +#define        AR5K_INIT_SIFS_HALF_RATE                32
>> +#define AR5K_INIT_SIFS_QUARTER_RATE            64
>> +
>>  /* Rx latency for 5 and 10MHz operation (max ?) */
>>  #define AR5K_INIT_RX_LAT_MAX                   63
>>  /* Tx latencies from initvals (5212 only but no problem
>> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
>> index ae99e37..cb6e277 100644
>> --- a/drivers/net/wireless/ath/ath5k/pcu.c
>> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
>> @@ -43,14 +43,27 @@
>>  static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
>>  {
>>        struct ieee80211_channel *channel = ah->ah_current_channel;
>> +       unsigned int slot_time;
>>
>> -       if (channel->hw_value & CHANNEL_TURBO)
>> -               return 6; /* both turbo modes */
>> +       switch (ah->ah_bwmode) {
>> +       case AR5K_BWMODE_40MHZ:
>> +               slot_time = AR5K_INIT_SLOT_TIME_TURBO;
>> +               break;
>> +       case AR5K_BWMODE_10MHZ:
>> +               slot_time = AR5K_INIT_SLOT_TIME_HALF_RATE;
>> +               break;
>> +       case AR5K_BWMODE_5MHZ:
>> +               slot_time = AR5K_INIT_SLOT_TIME_QUARTER_RATE;
>> +               break;
>> +       case AR5K_BWMODE_DEFAULT:
>> +               slot_time = AR5K_INIT_SLOT_TIME_DEFAULT;
>> +       default:
>> +               if (channel->hw_value & CHANNEL_CCK)
>> +                       slot_time = AR5K_INIT_SLOT_TIME_B;
>> +               break;
>> +       }
>>
>> -       if (channel->hw_value & CHANNEL_CCK)
>> -               return 20; /* 802.11b */
>> -
>> -       return 9; /* 802.11 a/g */
>> +       return slot_time;
>>  }
>>
>>  /**
>> @@ -58,17 +71,30 @@ static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
>>  *
>>  * @ah: The &struct ath5k_hw
>>  */
>> -static unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
>> +unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
>>  {
>>        struct ieee80211_channel *channel = ah->ah_current_channel;
>> +       unsigned int sifs;
>>
>> -       if (channel->hw_value & CHANNEL_TURBO)
>> -               return 8; /* both turbo modes */
>> +       switch (ah->ah_bwmode) {
>> +       case AR5K_BWMODE_40MHZ:
>> +               sifs = AR5K_INIT_SIFS_TURBO;
>> +               break;
>> +       case AR5K_BWMODE_10MHZ:
>> +               sifs = AR5K_INIT_SIFS_HALF_RATE;
>> +               break;
>> +       case AR5K_BWMODE_5MHZ:
>> +               sifs = AR5K_INIT_SIFS_QUARTER_RATE;
>> +               break;
>> +       case AR5K_BWMODE_DEFAULT:
>> +               sifs = AR5K_INIT_SIFS_DEFAULT_BG;
>> +       default:
>> +               if (channel->hw_value & CHANNEL_5GHZ)
>> +                       sifs = AR5K_INIT_SIFS_DEFAULT_A;
>> +               break;
>> +       }
>>
>> -       if (channel->hw_value & CHANNEL_5GHZ)
>> -               return 16; /* 802.11a */
>> -
>> -       return 10; /* 802.11 b/g */
>> +       return sifs;
>>  }
>>
>>  /**
>> diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
>> index c422d5c..6eb6838 100644
>> --- a/drivers/net/wireless/ath/ath5k/qcu.c
>> +++ b/drivers/net/wireless/ath/ath5k/qcu.c
>> @@ -297,7 +297,8 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
>>
>>                /* Set Slot time */
>>                ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
>> -                       AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
>> +                       AR5K_INIT_SLOT_TIME_TURBO_CLOCK :
>> +                       AR5K_INIT_SLOT_TIME_CLOCK,
>>                        AR5K_SLOT_TIME);
>>                /* Set ACK_CTS timeout */
>>                ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
>> @@ -306,15 +307,16 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
>>
>>                /* Set IFS0 */
>>                if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
>> -                       ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
>> -                               tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO) <<
>> -                               AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
>> +                       ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO_CLOCK +
>> +                               tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO_CLOCK)
>> +                               << AR5K_IFS0_DIFS_S) |
>> +                               AR5K_INIT_SIFS_TURBO_CLOCK,
>>                                AR5K_IFS0);
>>                } else {
>> -                       ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
>> -                               tq->tqi_aifs * AR5K_INIT_SLOT_TIME) <<
>> +                       ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_CLOCK +
>> +                               tq->tqi_aifs * AR5K_INIT_SLOT_TIME_CLOCK) <<
>>                                AR5K_IFS0_DIFS_S) |
>> -                               AR5K_INIT_SIFS, AR5K_IFS0);
>> +                               AR5K_INIT_SIFS_CLOCK, AR5K_IFS0);
>>                }
>>
>>                /* Set IFS1 */
>> _______________________________________________
>> ath5k-devel mailing list
>> ath5k-devel@lists.ath5k.org
>> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>>
>
