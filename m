Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33189 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KXAyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 19:54:11 -0500
Received: by wyb28 with SMTP id 28so8904105wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 16:54:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimnRS1Mh4KtjFNJOcUEb-JNDs+B8vqFbkh-EybL@mail.gmail.com>
References: <20101123190911.GN4303@makis.mantri>
	<AANLkTimnRS1Mh4KtjFNJOcUEb-JNDs+B8vqFbkh-EybL@mail.gmail.com>
Date: Wed, 24 Nov 2010 02:54:08 +0200
Message-ID: <AANLkTi=B32GVseEr-GAkp-kiTUsy0cgU1BHO-7Tim1Sm@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 14/30] ath5k: Extend get_default_sifs/slot_time
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/24 Jonathan Guerin <jonathan@guerin.id.au>:
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
>

All _CLOCK variables are left here temporarily until we clean up
AR5210 stuff later, i know it's wrong ;-)
Check out patch 16 that adds the new set_ifs_intervals, there we set
them property, i just left them here so that code can still compile.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
