Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15670 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1EFQPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:15:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 09:15:21 -0700
Date: Fri, 6 May 2011 21:45:42 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>
Subject: Re: [RFC] ath9k: make npending frames check as bool
Message-ID: <20110506161541.GB6002@vasanth-laptop> (sfid-20110506_181553_187515_3E34EB83)
References: <1304697291-6850-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1304697291-6850-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 06, 2011 at 09:24:51PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3de115d..2b78ea2 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2267,7 +2267,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>  		timeout = 1;
>  
>  	for (j = 0; j < timeout; j++) {
> -		int npend = 0;
> +		bool npend = false;
>  
>  		if (j)
>  			usleep_range(1000, 2000);
> @@ -2276,7 +2276,10 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
>  			if (!ATH_TXQ_SETUP(sc, i))
>  				continue;
>  
> -			npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
> +			npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
> +
> +			if (npend)
> +				break;

We need not bail out as soon as there is a pending frame in a queue.
There is a possibility that it could be transmitted successfully by
the time the given timeout expires.

Vasanth
