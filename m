Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1IOJTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:19:21 -0400
Subject: Re: [RFC] wireless: Fix rate mask for scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316078089-7221-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316078089-7221-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:19:18 +0200
Message-ID: <1316078358.3992.4.camel@jlt3.sipsolutions.net> (sfid-20110915_111925_539359_787BCAA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 14:44 +0530, Rajkumar Manoharan wrote:
> The scan request received from cfg80211_connect do not
> have proper rate mast. So the probe request sent on each
> channel do not have proper the supported rates ie.
> 
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/wireless/sme.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index b7b6ff8..8b6ef34 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -118,6 +118,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
>  			     i++, j++)
>  				request->channels[i] =
>  					&wdev->wiphy->bands[band]->channels[j];
> +			request->rates[band] = (u32) -1;

Please use
	(1 << wiphy->bands[band]->n_bitrates) - 1;

so we don't have invalid bits set.

Also, CC stable doesn't work that way -- you don't CC them, you just
write into it "Cc: stable@kernel.org". This makes them pick out the
patch later once it got applied.

johannes

