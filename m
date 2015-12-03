Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59056 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbbLCHur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 02:50:47 -0500
Message-ID: <1449129039.2181.0.camel@sipsolutions.net> (sfid-20151203_085051_053962_5EA3298E)
Subject: Re: wireless-testing regression: Could not configure driver mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Dec 2015 08:50:39 +0100
In-Reply-To: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_075426_533282_0EE08AA8)
References: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com>
	 (sfid-20151203_075426_533282_0EE08AA8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 08:54 +0200, Kalle Valo wrote:
> 
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -916,6 +916,13 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy,
> struct wireless_dev *wdev,
>                         kfree_skb(skb);
>                         goto out_unlock;
>                 }
> +       } else {
> +               /* Assign a dummy non-zero cookie, it's not sent to
> +                * userspace in this case but we rely on its value
> +                * internally in the need_offchan case to distinguish
> +                * mgmt-tx from remain-on-channel.
> +                */
> +               *cookie = 0xffffffff;
> 

FWIW, this part isn't relevant for the problem and not actually an
error - this just went into my tree after that was merged into
wireless-testing :)

johannes
