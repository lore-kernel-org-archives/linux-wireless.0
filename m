Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3BDQDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 11:03:53 -0500
Message-ID: <1359993855.17993.5.camel@jlt4.sipsolutions.net> (sfid-20130204_170357_023971_04956D3D)
Subject: Re: [PATCH] {cfg,nl}80211: tx_mgmt: use current bss channel if
 omitted.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 17:04:15 +0100
In-Reply-To: <1359738683-13499-1-git-send-email-cavallar@lri.fr>
References: <510A7D40.2030206@lri.fr>
	 <1359738683-13499-1-git-send-email-cavallar@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 18:11 +0100, Nicolas Cavallari wrote:
> Allow not specifying the channel when transmitting a management frame.
> This allows user space code to not track the current channel.  This is
> especially useful in IBSS mode, because userspace is not informed when
> the channel changes because of a merge and requesting the current
> channel before using it can introduce races.


> @@ -836,10 +837,23 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
>  			err = -EOPNOTSUPP;
>  			break;
>  		}
> +		if (!err && chan == NULL) {
> +			cfg80211_get_chan_state(wdev, &chan, &chan_mode);

I'm not sure this is the best way of handling it. Is there a reason to
not pass NULL through to the driver(s) (and audit them) instead? This
channel access could be racy for channel changes still, etc.

johannes

