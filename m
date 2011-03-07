Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58522 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1CGTAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 14:00:45 -0500
Date: Mon, 7 Mar 2011 13:54:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH] iwlagn: fix offchannel TX bug
Message-ID: <20110307185429.GD2664@tuxdriver.com>
References: <1299350139.29845.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299350139.29845.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 05, 2011 at 07:35:39PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In the case where remain-on-channel rather than
> offchannel TX should be used, my offchannel TX
> patch introduced a bug because mac80211 will
> use the now-freed SKB.
> 
> iwlagn shouldn't free the SKB when it returns 1
> here since then the SKB will still be used.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:32:58.000000000 +0100
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:33:08.000000000 +0100
> @@ -3171,7 +3171,7 @@ static int iwl_mac_offchannel_tx(struct
>   out:
>  	mutex_unlock(&priv->mutex);
>   free:
> -	if (ret)
> +	if (ret < 0)
>  		kfree_skb(skb);
>  
>  	return ret;

OK, I give-up...what tree is this against? :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
