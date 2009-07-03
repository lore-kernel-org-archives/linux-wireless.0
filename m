Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46796 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbZGCAQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 20:16:11 -0400
Message-ID: <4A4D4DC6.30502@openwrt.org>
Date: Fri, 03 Jul 2009 02:16:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, kalle.valo@nokia.com,
	vidhya.govindan@nokia.com
Subject: Re: [PATCH] mac80211: minstrel: avoid accessing negative indices
 in rix_to_ndx()
References: <1246571549-29014-1-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1246571549-29014-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho wrote:
> If rix is not found in mi->r[], i will become -1 after the loop.  This value
> is eventually used to access arrays, so we were accessing arrays with a
> negative index, which is obviously not what we want to do.  This patch fixes
> this potential problem.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  net/mac80211/rc80211_minstrel.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index b218b98..e2dd248 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>  	for (i = rix; i >= 0; i--)
>  		if (mi->r[i].rix == rix)
>  			break;
> -	WARN_ON(mi->r[i].rix != rix);
> +	WARN_ON(i < 0 || mi->r[i].rix != rix);
I believe this line could be changed to WARN_ON(i < 0), because
(mi->r[i].rix != rix) will never be true unless i < 0.
Probably not that important though.

Acked-by: Felix Fietkau <nbd@openwrt.org>

- Felix
