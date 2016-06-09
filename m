Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58028 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424480AbcFIH6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 03:58:04 -0400
Message-ID: <1465459080.3442.2.camel@sipsolutions.net> (sfid-20160609_095810_154226_06D7286F)
Subject: Re: [PATCH] nl80211: avoid possible memleak on nl80211_set_reg
From: Johannes Berg <johannes@sipsolutions.net>
To: Eduardo Abinader <eabinader@ocedo.com>,
	linux-wireless@vger.kernel.org
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>
Date: Thu, 09 Jun 2016 09:58:00 +0200
In-Reply-To: <1465224967-26892-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160606_165618_946135_D46C5895)
References: <1465224967-26892-1-git-send-email-eduardo.abinader@riverbed.com>
	 (sfid-20160606_165618_946135_D46C5895)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-06 at 16:56 +0200, Eduardo Abinader wrote:
> Setting NULL just after freeing regdomain.
> 
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index d120449..39d107d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5839,10 +5839,11 @@ static int nl80211_set_reg(struct sk_buff
> *skb, struct genl_info *info)
>  
>  	r = set_regdom(rd, REGD_SOURCE_CRDA);
>  	/* set_regdom took ownership */
> -	rd = NULL;
>  
>   bad_reg:
>  	kfree(rd);
> +	rd = NULL;

To this I can only say: what?

johannes
