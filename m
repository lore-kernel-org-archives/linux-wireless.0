Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2E2HNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:13:53 -0400
Message-ID: <1338275635.4342.24.camel@jlt3.sipsolutions.net> (sfid-20120529_091356_723050_716274E1)
Subject: RE: [PATCH 3/3] mwifiex: fix kernel warning in ibss start/join path
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 29 May 2012 09:13:55 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A64BA49@SC-VEXCH1.marvell.com>
References: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
	 <1337228696-22312-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120517_063333_463261_998602DE) <1337238333.4524.1.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A64B448@SC-VEXCH1.marvell.com>
	 <1337284374.4687.6.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A64BA49@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-21 at 19:43 -0700, Bing Zhao wrote:
> Hi Johannes,
> 
> > > In .join_ibss handler, mwifiex driver sends a command to firmware to start/join an IBSS network.
> > > This command is a synchronous call. When the command response comes
> > > back we have started/joined it successfully, otherwise an error code
> > > will be returned. However, we are still inside .join_ibss handler at
> > > this moment. Calling cfg80211_ibss_joined() gives us the warning
> > > because ssid_len hasn't been set by cfg80211 yet.
> > 
> > Hmm. Interesting, because I would think that could potentially take
> > quite a while?
> > 
> > It's interesting though because it points out that even if you do call
> > it asynchronously, there's no guarantee that it actually happens before
> > the function call returns. Maybe we should just move the assignment in
> > cfg80211 instead?
> 
> Can we use "sme_state != CFG80211_SME_CONNECTING" check for ibss path too?

I don't think that variable is updated for IBSS at all?

> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 30f20fe..3d0930d 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -42,6 +42,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
>  	cfg80211_hold_bss(bss_from_pub(bss));
>  	wdev->current_bss = bss_from_pub(bss);
>  
> +	wdev->sme_state = CFG80211_SME_CONNECTED;
>  	cfg80211_upload_connect_keys(wdev);
>  
>  	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid,
> @@ -60,7 +61,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
>  	struct cfg80211_event *ev;
>  	unsigned long flags;
>  
> -	CFG80211_DEV_WARN_ON(!wdev->ssid_len);
> +	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING);
>  
>  	ev = kzalloc(sizeof(*ev), gfp);
>  	if (!ev)
> @@ -115,9 +116,11 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
>  #ifdef CONFIG_CFG80211_WEXT
>  	wdev->wext.ibss.channel = params->channel;
>  #endif
> +	wdev->sme_state = CFG80211_SME_CONNECTING;
>  	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
>  	if (err) {
>  		wdev->connect_keys = NULL;
> +		wdev->sme_state = CFG80211_SME_IDLE;
>  		return err;
>  	}
>  
> @@ -169,6 +172,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
>  	}
>  
>  	wdev->current_bss = NULL;
> +	wdev->sme_state = CFG80211_SME_IDLE;
>  	wdev->ssid_len = 0;
>  #ifdef CONFIG_CFG80211_WEXT
>  	if (!nowext)

Ah, you're updating it now.

Hmm, interesting. Seems reasonable to me.

johannes

