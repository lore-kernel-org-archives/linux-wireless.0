Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:51669 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYASWYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 17:24:17 -0500
Received: by py-out-1112.google.com with SMTP id u52so2187924pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2008 14:24:16 -0800 (PST)
Message-ID: <43e72e890801191424g350c7530ye47ca306f6bef30c@mail.gmail.com> (sfid-20080119_222421_579570_31619A6C)
Date: Sat, 19 Jan 2008 17:24:15 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/4] ath5k: use 3 instead of 0x00000003
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080118125119.6342.99381.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125018.6342.94435.stgit@one>
	 <20080118125119.6342.99381.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 18, 2008 7:51 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> reviewed beacon timer initialization with register traces from madwifi: what we
> are doing is correct :). one minor fix: use 3 instead of 0x00000003 - it's more
> readable.
>
> drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>
>  drivers/net/wireless/ath5k/hw.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
>
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index eb00818..3a4bf40 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -2605,10 +2605,8 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
>                 break;
>
>         default:
> -               timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) <<
> -                   0x00000003;
> -               timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) <<
> -                   0x00000003;
> +               timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) << 3;
> +               timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) << 3;
>         }
>
>         timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
>
>

Sure why not,

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
