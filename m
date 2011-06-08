Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1FHNT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:19:26 -0400
Subject: Re: [PATCH] cfg80211: Ignore downstream DEAUTH for authtry_bsses
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110608131433.DC6B62034B@glenhelen.mtv.corp.google.com> (sfid-20110608_151437_104479_55A471AC)
References: <a194a41b3f1376f035113d4f443038eb2e64264f.1307403076.git.pstew@chromium.org>
	 <1307530922.3961.4.camel@jlt3.sipsolutions.net>
	 <BANLkTimdAHt9VUUmNB2uzgm8ymeo6J+EeA@mail.gmail.com>
	 <1307533479.3961.13.camel@jlt3.sipsolutions.net>
	 <BANLkTikc-6hwZwT4Qt-dB-qBkwxEWLwrkg@mail.gmail.com>
	 <1307533801.3961.14.camel@jlt3.sipsolutions.net>
	 <20110608131433.DC6B62034B@glenhelen.mtv.corp.google.com>
	 (sfid-20110608_151437_104479_55A471AC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 15:19:24 +0200
Message-ID: <1307539164.30277.4.camel@jlt3.sipsolutions.net> (sfid-20110608_151932_956780_DC6B4E79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 05:52 -0700, Paul Stewart wrote:
> Downsteram DEAUTH messages do not refer to a current authentication
> attempt -- AUTH responses do.  Therefore we should not allow DEAUTH
> from an AP to void state for an AUTH attempt in progress.

Could you reproduce the original problem? This looks nice.

> Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---
>  net/wireless/mlme.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 493b939..3633ab6 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -170,7 +170,9 @@ void __cfg80211_send_deauth(struct net_device *dev,
>  			break;
>  		}
>  		if (wdev->authtry_bsses[i] &&
> -		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
> +		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
> +			   ETH_ALEN) == 0 &&
> +		    memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) == 0) {
>  			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
>  			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
>  			wdev->authtry_bsses[i] = NULL;


