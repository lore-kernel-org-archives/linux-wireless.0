Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:46588 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753997AbYBEJrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 04:47:32 -0500
From: bruno randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 6/7] ath5k: Use software encryption for now
Date: Tue, 5 Feb 2008 18:47:21 +0900
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linville@tuxdriver.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <6571fb0f1b7c8435e6306745e6cf71366f306440.1202092325.git.mcgrof@winlab.rutgers.edu>
In-Reply-To: <6571fb0f1b7c8435e6306745e6cf71366f306440.1202092325.git.mcgrof@winlab.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802051847.21743.bruno@thinktube.com> (sfid-20080205_094735_316909_CE166C1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 February 2008 11:53:20 Luis R. Rodriguez wrote:
> Hardware encryption doesn't work yet so lets use software
> encryption for now.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> ---
>  drivers/net/wireless/ath5k/base.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c index bfe6836..ef9655c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2922,7 +2922,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
> set_key_cmd cmd,
>
>  	switch(key->alg) {
>  	case ALG_WEP:
> -		break;
> +	/* XXX: fix hardware encryption, its not working. For now
> +	 * allow software encryption */
> +		/* break; */
>  	case ALG_TKIP:
>  	case ALG_CCMP:
>  		return -EOPNOTSUPP;

yep, works for me :)

Acked-by: Bruno Randolf <bruno@thinktube.com>
