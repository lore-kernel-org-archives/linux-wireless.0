Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3AXH3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 02:29:34 -0500
Message-ID: <1359012504.6252.187.camel@cumari.coelho.fi> (sfid-20130124_082939_777869_5990599C)
Subject: Re: [patch] cfg80211: off by one in ieee80211_bss()
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Date: Thu, 24 Jan 2013 09:28:24 +0200
In-Reply-To: <20130124064000.GB5611@elgon.mountain>
References: <20130124064000.GB5611@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 09:40 +0300, Dan Carpenter wrote:
> We do a:
> 
> 	sprintf(buf, " Last beacon: %ums ago",
> 		elapsed_jiffies_msecs(bss->ts));
> 
> elapsed_jiffies_msecs() can return a 10 digit number so "buf" needs to
> be 31 characters long.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 01592d7..45f1618 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -1358,7 +1358,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
>  						  &iwe, IW_EV_UINT_LEN);
>  	}
>  
> -	buf = kmalloc(30, GFP_ATOMIC);
> +	buf = kmalloc(31, GFP_ATOMIC);
>  	if (buf) {
>  		memset(&iwe, 0, sizeof(iwe));
>  		iwe.cmd = IWEVCUSTOM;

Looks good.  Also, to be on the safe side, shouldn't snprintf be used
when writing to buf as well? Same thing higher up where the same buf is
used and alloc'ed 50 bytes...

--
Luca.

