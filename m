Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1304 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150Ab0FTSaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 14:30:21 -0400
Message-ID: <4C1E5E3B.8040105@gmail.com>
Date: Sun, 20 Jun 2010 20:30:19 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] mac80211: Fix compile warning in scan.c.
References: <1277058487-11803-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1277058487-11803-1-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/10 20:28, Gertjan van Wingerde wrote:
> Fix the following compile warning:
> 
> CC [M]  net/mac80211/scan.o
> net/mac80211/scan.c: In function 'ieee80211_request_internal_scan':
> net/mac80211/scan.c:749:23: warning: comparison between 'enum nl80211_band' and 'enum ieee80211_band'
> 
> caused by the local variable band not being of the proper 'ieee80211_band' type.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  net/mac80211/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 30d4c0d..9aa19ec 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -735,7 +735,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	int ret = -EBUSY;
> -	enum nl80211_band band;
> +	enum ieee80211_band band;
>  
>  	mutex_lock(&local->scan_mtx);
>  


Sorry about the 11/11 in the subject. This patch is completely on its own. It is just part of the ongoing
work in my own tree and I forgot to remove the 11/11 marking before sending out the patch.

---
Gertjan.
