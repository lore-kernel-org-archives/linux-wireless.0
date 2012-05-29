Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2E2HSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:18:13 -0400
Message-ID: <1338275896.4342.28.camel@jlt3.sipsolutions.net> (sfid-20120529_091825_338190_6095D364)
Subject: Re: [PATCH] mac80211: fail authentication when AP denied
 authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:18:16 +0200
In-Reply-To: <1336921624-5698-1-git-send-email-eliad@wizery.com> (sfid-20120513_170739_487467_DF65A8B5)
References: <1336921624-5698-1-git-send-email-eliad@wizery.com>
	 (sfid-20120513_170739_487467_DF65A8B5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-05-13 at 18:07 +0300, Eliad Peller wrote:
> ieee80211_rx_mgmt_auth() doesn't handle denied authentication
> properly - it authenticates the station and waits for association
> (for 5 seconds) instead of failing the authentication.
> 
> Fix it by destroying auth_data and bailing out instead.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Cc: stable now that this code shipped in 3.4? (or didn't it?)

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/mlme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index dbd4bd9..2b5235e 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1790,7 +1790,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
>  	if (status_code != WLAN_STATUS_SUCCESS) {
>  		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
>  		       sdata->name, mgmt->sa, status_code);
> -		goto out;
> +		ieee80211_destroy_auth_data(sdata, false);
> +		return RX_MGMT_CFG80211_RX_AUTH;
>  	}
>  
>  	switch (ifmgd->auth_data->algorithm) {
> @@ -1812,7 +1813,6 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
> - out:
>  	ifmgd->auth_data->done = true;
>  	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
>  	run_again(ifmgd, ifmgd->auth_data->timeout);


