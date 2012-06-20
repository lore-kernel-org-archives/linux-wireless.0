Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2FTITu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:19:50 -0400
Message-ID: <1340180381.4655.25.camel@jlt3.sipsolutions.net> (sfid-20120620_102000_475374_4FDFCA75)
Subject: Re: [RFCv2 05/13] cfg80211: introduce cfg80211_get_chan_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:19:41 +0200
In-Reply-To: <1340172859-18146-6-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-6-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> Helper function for finding out which channel is
> used by a given interface.
> 
> An exclusive channel can be used only by a single
> interface. This is mainly for non-fixed channel
> IBSS handling.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/wireless/chan.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/core.h |   12 ++++++++++++
>  2 files changed, 63 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index c1999e4..167e7cb 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -92,3 +92,54 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
>  
>  	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
>  }
> +
> +void
> +cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
> +		        struct wireless_dev *wdev,
> +		        struct ieee80211_channel **chan,
> +		        enum cfg80211_chan_mode *chanmode)

Why not return the mode rather than void & pointer?

johannes

