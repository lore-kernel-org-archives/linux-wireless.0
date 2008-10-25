Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:45845 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYJYXWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 19:22:00 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1485027rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2008 16:21:59 -0700 (PDT)
Message-ID: <40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com> (sfid-20081026_012217_558603_63653D99)
Date: Sun, 26 Oct 2008 02:21:59 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87prlr9mna.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87prlr9mna.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/23 Elias Oltmanns <eo@nebensachen.de>:
> Take care to handle register 0xa228 exactly as in the HAL released by
> Atheros. This change is required to make ath5k work again on my system
> since commit 2203d6be (ath5k: Misc hw_reset updates), thus fixing a
> regression in 2.6.27 and therefore hopefully eligible for inclusion into
> a stable release.
>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---
> Applies to 2.6.27. Please let me know if I should do something
> differently and resend.
>
>  drivers/net/wireless/ath5k/hw.c       |    1 +
>  drivers/net/wireless/ath5k/initvals.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
>

Current code works fine on my CM6 (AR5212 + RF5111) and i see nothing like

data |= 0x00000800

on the HAL Atheros released

Problem is that we are updating 0xa228 (RSSI threshold in this case)
for all AR5212 based cards and we are not checking right now for BB
revision. These settings according to Atheros HAL are only for BB
revisions > 2. I'm going to update reset.c this week hopefully.

BTW can you please run latest ath_info on your card ? Let's see what's
the rssi threshold stored on EEPROM and how much different is from my
card.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
