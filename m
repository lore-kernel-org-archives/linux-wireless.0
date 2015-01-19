Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60600 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbbASJ63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 04:58:29 -0500
Message-ID: <1421661507.1965.17.camel@sipsolutions.net> (sfid-20150119_105832_521644_E4694B93)
Subject: Re: [PATCH] mac80211: correct header length calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Jan 2015 10:58:27 +0100
In-Reply-To: <1421640460-5094-1-git-send-email-fred.chou.nd@gmail.com> (sfid-20150119_050500_426967_E98C7167)
References: <1421640460-5094-1-git-send-email-fred.chou.nd@gmail.com>
	 (sfid-20150119_050500_426967_E98C7167)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 12:07 +0800, Fred Chou wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> HT Control field may also be present in management frames, as defined
> in 8.2.4.1.10 of 802.11-2012. Account for this in calculation of 
> header length.
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
> ---
>  net/wireless/util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 1d2fcfa..ce9617c 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -297,6 +297,12 @@ unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc)
>  {
>  	unsigned int hdrlen = 24;
>  
> +	if (ieee80211_is_mgmt(fc)) {
> +		if (ieee80211_has_order(fc))
> +			hdrlen += IEEE80211_HT_CTL_LEN;
> +		goto out;
> +	}
> +
>  	if (ieee80211_is_data(fc)) {

I think you should insert this after data since data frames are more
common.

johannes

