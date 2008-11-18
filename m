Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41530 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYKRTbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 14:31:16 -0500
Date: Tue, 18 Nov 2008 14:23:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Frank Seidel <fseidel@suse.de>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
Subject: Re: [PATCH] Re: Problem with Kernel Oops in ipw2200
Message-ID: <20081118192321.GC21772@tuxdriver.com> (sfid-20081118_203146_473976_A4348626)
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de> <20081112213350.GJ2411@tuxdriver.com> <491BF062.4050705@suse.de> <1226631539.2604.411.camel@debian.sh.intel.com> <49214BF3.8050306@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49214BF3.8050306@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 11:48:19AM +0100, Frank Seidel wrote:
> From: Zhu Yi <yi.zhu@intel.com>
> 
> Fixes Oops in ipw2200:ipw_tx_skb when pinging through
> a WPA enterprise connection.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> Tested-by: Frank Seidel <fseidel@suse.de>
> Signed-off-by: Ffrank Seidel <fseidel@suse.de>
> 
> ---
>  drivers/net/wireless/ipw2200.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -10190,6 +10190,11 @@ static int ipw_tx_skb(struct ipw_priv *p
>  	u16 remaining_bytes;
>  	int fc;
>  
> +	if (!(priv->status & STATUS_ASSOCIATED)) {
> +		IPW_DEBUG_TX("Tx attempt while not associated.\n");
> +		goto drop;
> +	}
> +
>  	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
>  	switch (priv->ieee->iw_mode) {
>  	case IW_MODE_ADHOC:
> 

Well, I'm sorry to be a PITA...but the changelog doesn't really
explain how the patch works or what it is doing.  Also, this still
seems to me more like a band-aid than a real fix...?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
