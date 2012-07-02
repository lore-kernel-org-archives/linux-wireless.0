Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2GEOwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 10:52:30 -0400
Date: Mon, 2 Jul 2012 14:25:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: dan.carpenter@oracle.com, wfg@linux.intel.com,
	linux-wireless@vger.kernel.org, franzschrober@yahoo.de,
	julian.calaby@gmail.com, johannes@sipsolutions.net, nbd@openwrt.org
Subject: Re: [PATCH] mac80211: fix kzalloc memory corruption introduced in
 minstrel_ht
Message-ID: <20120702182517.GC2010@tuxdriver.com> (sfid-20120705_165239_998667_2708C6D6)
References: <1341232792-6247-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341232792-6247-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 02, 2012 at 02:39:52PM +0200, Thomas Huehn wrote:
> The patch: "mac80211: correct size the argument to
> kzalloc in minstrel_ht" (from Jun 29, 2012), leads to memory corruption.
> "msp->ratelist" is a void pointer - therfore going back to the
> expicit form: sizeof(struct minstrel_rate) which brings back correct
> memory allocation.
> 
> Reported-by: Fengguang Wu <wfg@linux.intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  net/mac80211/rc80211_minstrel_ht.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 1ca8f2b..f9e51ef 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -813,7 +813,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
>  	if (!msp)
>  		return NULL;
>  
> -	msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);
> +	msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
>  	if (!msp->ratelist)
>  		goto error;
>  

Johannes, I'm grabbing this one now.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
