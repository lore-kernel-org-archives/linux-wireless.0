Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37467 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0CDOVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 09:21:48 -0500
Received: by wya21 with SMTP id 21so1451907wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 06:21:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1003031530l2a89c265t98a8560bdbf9c758@mail.gmail.com>
References: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
	 <b6c5339f1003031530l2a89c265t98a8560bdbf9c758@mail.gmail.com>
Date: Thu, 4 Mar 2010 09:21:46 -0500
Message-ID: <6b5e31691003040621ge2ca051n1bb3abb4b0158546@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
From: Andrew Blaich <ablaich@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updating the patch to include the removal of  the define of
AR5K_TUNE_HWTXTRIES per Benoit's suggestion as the patch makes it no
longer necessary.

Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h
b/drivers/net/wireless/ath/ath5k/ath5k.h
index ac67f02..1c5834a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -202,7 +202,6 @@
 #define AR5K_TUNE_MAX_TXPOWER			63
 #define AR5K_TUNE_DEFAULT_TXPOWER		25
 #define AR5K_TUNE_TPC_TXPOWER			false
-#define AR5K_TUNE_HWTXTRIES			4

 #define AR5K_INIT_CARR_SENSE_EN			1

diff --git a/drivers/net/wireless/ath/ath5k/desc.c
b/drivers/net/wireless/ath/ath5k/desc.c
index dc30a2b..c18d8d4 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
 	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
 					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
-	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
+	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
 					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
 	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;


On Wed, Mar 3, 2010 at 6:30 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Mar 1, 2010 at 10:30 AM, Andrew Blaich <ablaich@gmail.com> wrote:
>> This Patch:
>>
>> The rate control algorithm, default is Minstrel for ath5k, determines
>> the number of retries to use for each rate.  However, there exists in
>> ath5k_hw_setup_4word_tx_desc (which is called for AR5212 like devices)
>> a set number of retries defined by AR5K_TUNE_HWTXTRIES.  The set
>> number of tries is added to the tx_tries0 variable setup by the rate
>> control algorithm.  This changes the number of retries the rate
>> control algorithm considers necessary.  By removing the
>> AR5K_TUNE_HWTXTRIES from the retry calculation the rate control
>> algorithm is given control over the number of retries.
>>
>>
>> Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
>> ---
>> diff --git a/drivers/net/wireless/ath/ath5k/desc.c
>> b/drivers/net/wireless/ath/ath5k/desc.c
>> index dc30a2b..c18d8d4 100644
>> --- a/drivers/net/wireless/ath/ath5k/desc.c
>> +++ b/drivers/net/wireless/ath/ath5k/desc.c
>> @@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>>                AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
>>        tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
>>                                        AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
>> -       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
>> +       tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
>
> Thanks!
>
> --
> Bob Copeland %% www.bobcopeland.com
>
