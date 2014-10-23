Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30725 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJWHNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 03:13:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: add SURVEY_INFO_IN_USE for current channel on survey
References: <1413996362-44397-1-git-send-email-nbd@openwrt.org>
Date: Thu, 23 Oct 2014 10:13:09 +0300
Message-ID: <87k33rqmwq.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_091319_416611_D4472D14)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 4670930..bc440dc 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3975,6 +3975,9 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
>  
>  	survey->channel = &sband->channels[idx];
>  
> +	if (ar->rx_channel == survey->channel)
> +		survey->filled |= SURVEY_INFO_IN_USE;
> +

Why? Does this fix a visible bug? What changes from user space point of
view? I'm asking because I want to add something to the commit log.

-- 
Kalle Valo
