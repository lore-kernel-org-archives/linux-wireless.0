Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbYCES0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:26:32 -0500
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
From: Dan Williams <dcbw@redhat.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 13:22:31 -0500
Message-Id: <1204741351.9378.11.camel@localhost.localdomain> (sfid-20080305_182636_537204_0260252D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-05 at 18:40 +0900, Joonwoo Park wrote:
> resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
> 
> The function ieee80211_ioctl_siwencode shouldn't be called if
> authentication process is not completed.
> This patch makes the ieee80211_ioctl_siwessid to wait for authentication
> is completed.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> ---
>  net/mac80211/ieee80211_ioctl.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> index 5024d37..55a29f6 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -391,6 +391,7 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
>  	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
>  	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
>  		int ret;
> +		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
>  		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
>  			if (len > IEEE80211_MAX_SSID_LEN)
>  				return -EINVAL;
> @@ -405,8 +406,15 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
>  		ret = ieee80211_sta_set_ssid(dev, ssid, len);
>  		if (ret)
>  			return ret;
> +
> +		set_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request);
> +
>  		ieee80211_sta_req_auth(dev, &sdata->u.sta);
> -		return 0;
> +
> +		ret = wait_event_interruptible_timeout(wq,
> +			!test_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request),
> +				HZ);
> +		return (ret == HZ) ? 0 : ret;

NAK; setting the SSID should never block for long; it _certainly_
shouldn't block waiting on other WEXT calls.  The association process
needs to be asynchronous.

Dan

>  	}
>  
>  	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {



