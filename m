Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:7348 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYAVBgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 20:36:51 -0500
Received: by an-out-0708.google.com with SMTP id d31so489469and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 17:36:50 -0800 (PST)
Message-ID: <40f31dec0801211736l211c59cbx72844326115af643@mail.gmail.com> (sfid-20080122_013656_992402_0E594FD6)
Date: Tue, 22 Jan 2008 03:36:50 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/4] ath5k: use 3 instead of 0x00000003
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080118125119.6342.99381.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125018.6342.94435.stgit@one>
	 <20080118125119.6342.99381.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/18, Bruno Randolf <bruno@thinktube.com>:
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


Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
