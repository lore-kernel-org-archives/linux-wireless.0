Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:36472 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcDOU7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 16:59:49 -0400
Received: by mail-qg0-f68.google.com with SMTP id f105so11262619qge.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2016 13:59:48 -0700 (PDT)
Date: Fri, 15 Apr 2016 16:59:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, lkml2017@openmailbox.org
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
Message-ID: <20160415205939.GA2894@localhost> (sfid-20160415_225952_125283_B5903FAE)
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2016 at 07:37:44PM +0200, Oleksij Rempel wrote:
> by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move
> mask_m & mask_p initialisation. This coused a performance regression
> on ar9281.
> 
> Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.")
> Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c | 8 +++-----
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c | 5 -----
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> index 8f87930..1b271b9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> @@ -274,6 +274,9 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
>  	};
>  	static const int inc[4] = { 0, 100, 0, 0 };
>  
> +	memset(&mask_m, 0, sizeof(int8_t) * 123);
> +	memset(&mask_p, 0, sizeof(int8_t) * 123);
> +

For a future patch, "sizeof(mask_m)" or even just:

    u8 mask_m[123] = {0};

... would be better here.  I looked at this bit and thought, no way is
"123" actually correct.  Lo and behold, that is actually the number of
array elements, whether that has a basis in something real or not :)

-- 
Bob Copeland %% http://bobcopeland.com/
