Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59944 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbbBIRyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 12:54:25 -0500
Received: by mail-lb0-f169.google.com with SMTP id f15so31309136lbj.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 09:54:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150118051111.31866.39208.stgit@114-36-241-182.dynamic.hinet.net>
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
	<20150118051111.31866.39208.stgit@114-36-241-182.dynamic.hinet.net>
Date: Mon, 9 Feb 2015 09:54:23 -0800
Message-ID: <CAJAp7OhcFTuYfc7JOKW1SrVRbucuSWg5jcFaoVnSDgBxsyo2ng@mail.gmail.com> (sfid-20150209_185429_730143_DD094C2D)
Subject: Re: [PATCH 6/7] net: wireless: wcn36xx: remove powersaving for wcn3620
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Green <andy.green@linaro.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 17, 2015 at 9:11 PM, Andy Green <andy.green@linaro.org> wrote:
> WCN3620 powersaving mode is not stable.  Disable it if we're
> on a wcn3620 chip type.
>
> Signed-off-by: Andy Green <andy.green@linaro.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index c4178c7..569d45b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -924,6 +924,10 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
>                 IEEE80211_HW_AMPDU_AGGREGATION |
>                 IEEE80211_HW_TIMING_BEACON_ONLY;
>
> +       /* 3620 powersaving currently unstable */
> +       if (wcn->chip_version == WCN36XX_CHIP_3620)
> +               wcn->hw->flags &= ~IEEE80211_HW_SUPPORTS_PS;
> +

Hi Andy,

I have the same problem (Data Abort Exception in wcnss) on 3680, this
with my wip smd code and a hacked up remoteproc-pil. I haven't spent
any effort on debugging this, but it looks like it's something related
to what we have ported to mainline (or lack thereof) rather than a
3620 specific issue.

Regards,
Bjorn
