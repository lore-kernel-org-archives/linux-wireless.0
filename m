Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41916 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZHLMfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 08:35:55 -0400
Received: by bwz19 with SMTP id 19so3710186bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 05:35:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090812115803.GA4876@vasanth-laptop>
References: <4A81BB1E.6040904@gmail.com> <20090812115803.GA4876@vasanth-laptop>
Date: Wed, 12 Aug 2009 14:35:55 +0200
Message-ID: <25e057c00908120535p1135be7ak399599fdca6b636f@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Prevent read buffer overflow
From: roel kluin <roel.kluin@gmail.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 1:58 PM, Vasanthakumar
Thiagarajan<vasanth@atheros.com> wrote:
> On Wed, Aug 12, 2009 at 12:10:30AM +0530, Roel Kluin wrote:
>> Prevent a read from valid_rate_index[] with a negative index
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> Maybe we should add this?
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
>> index ba06e78..a67b7f6 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>> @@ -1458,7 +1458,7 @@ static void ath_rc_init(struct ath_softc *sc,
>>                 ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
>>         }
>>         ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
>> -       ASSERT(k <= RATE_TABLE_SIZE);
>> +       ASSERT(k <= RATE_TABLE_SIZE && k >= 4);
>
>
> NACK, k is initialized to 0 in the for loop few lines above this
> ASSERT.
>
> Vasanth

You could be right, but please explain, I don't understand:

k can only increment if ath_rc_priv->valid_phy_ratecnt[i] != 0
for i = 0 to WLAN_RC_PHY_MAX,

A few lines above these `ath_rc_priv->valid_phy_ratecnt[]'
are initialized to 0.

Say there was no working rate, and we call ath_rc_init_validrates(),

then in ath_rc_init_validrates()
ath_rc_priv->valid_phy_ratecnt[] can be initialized in this loop:

for (i = 0; i < rate_table->rate_cnt; i++) {
    ...
}

but where is this rate_cnt initialized?

[roel@zoinx linux-git]$ git grep rate_cnt
drivers/net/wireless/ath/ath9k/debug.c: max = 80 +
sc->cur_rate_table->rate_cnt * 64;
drivers/net/wireless/ath/ath9k/debug.c: for (i = 0; i <
sc->cur_rate_table->rate_cnt; i++) {
drivers/net/wireless/ath/ath9k/main.c:  if (rate_table->rate_cnt > ATH_RATE_MAX)
drivers/net/wireless/ath/ath9k/main.c:          maxrates = rate_table->rate_cnt;
drivers/net/wireless/ath/ath9k/rc.c:    for (i = 0; i <
rate_table->rate_cnt; i++) {
drivers/net/wireless/ath/ath9k/rc.c:            for (j = 0; j <
rate_table->rate_cnt; j++) {
drivers/net/wireless/ath/ath9k/rc.c:            for (j = 0; j <
rate_table->rate_cnt; j++) {
drivers/net/wireless/ath/ath9k/rc.c:    if ((tx_rate < 0) || (tx_rate
> rate_table->rate_cnt))
drivers/net/wireless/ath/ath9k/rc.h:    int rate_cnt;

Roel
