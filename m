Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3418 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbYDRB7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 21:59:32 -0400
Date: Thu, 17 Apr 2008 21:35:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] mac80211: correct skb allocation
Message-ID: <20080418013515.GB3152@tuxdriver.com> (sfid-20080418_025941_636979_7C33B303)
References: <1208473514-16688-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1208473514-16688-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 17, 2008 at 04:05:14PM -0700, Reinette Chatre wrote:
> From: Ester Kummer <ester.kummer@intel.com>
> 
> This patch corrects the allocation of skb in ADDBA req/resp and DELBA
> it removes redundant space u.addba_* are already counted in sizeof(*mgmt)
> 
> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c0a5345..b0b079c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1098,8 +1098,8 @@ static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u16 tid,
>  	struct ieee80211_mgmt *mgmt;
>  	u16 capab;
>  
> -	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
> -					sizeof(mgmt->u.action.u.addba_resp));
> +	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
> +

Forgive my ignorant, unresearched question... :-)  What was the "+1"
and why is it no longer necessary?

John
-- 
John W. Linville
linville@tuxdriver.com
