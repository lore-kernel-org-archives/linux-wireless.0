Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:64711 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0LORqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 12:46:18 -0500
Received: by iwn37 with SMTP id 37so2503576iwn.11
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 09:46:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292427053-5880-7-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com> <1292427053-5880-7-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Dec 2010 09:45:56 -0800
Message-ID: <AANLkTi=kyajwHzDUCK-+pikGNggz3uZJPEHvFdcH+un0@mail.gmail.com>
Subject: Re: [PATCH 7/7] ath9k_hw: Configure appropriate Tx power when PAPRD fails
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 7:30 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Target Tx power available in eeprom is for PAPRD. If PAPRD
> fails, paprd scale factor needs to be detected from this
> target tx power.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   34 ++++++++++++++++++++---
>  drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |   14 ++++++++++
>  drivers/net/wireless/ath/ath9k/hw.c            |    2 +
>  drivers/net/wireless/ath/ath9k/hw.h            |    1 +
>  drivers/net/wireless/ath/ath9k/main.c          |    2 +-
>  5 files changed, 47 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 0e9ea35..f80ec74 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -4743,6 +4743,16 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
>        } /* end ctl mode checking */
>  }
>
> +static inline u8 mcsidx_to_tgtpwridx(unsigned int mcs_idx, u8 base_pwridx)
> +{

No need to inline as its used only once so gcc will do that for you anyway.

  Luis
