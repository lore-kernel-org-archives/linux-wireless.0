Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaJ0FqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 01:46:12 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8723au: create macro get_max_rate
References: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com>
Date: Mon, 27 Oct 2014 06:46:04 +0100
In-Reply-To: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com> (Paul
	McQuade's message of "Mon, 27 Oct 2014 00:05:00 +0000")
Message-ID: <wrfja94icbfn.fsf@redhat.com> (sfid-20141027_064629_214223_0E48251E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul McQuade <paulmcquad@gmail.com> writes:
> create marco for max_rate values
>
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 58 ++++++++++++--------------
>  1 file changed, 26 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> index 6274cb3..4c0414d 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> @@ -13,6 +13,8 @@
>   *
>   ******************************************************************************/
>  #define _IEEE80211_C
> +#define get_max_rate(r1, r2, r3, r4)					\
> +	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))

NACK!

Don't hide parameters like that!

Jes
