Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:53773 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046Ab2F0Tsv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 15:48:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>
Date: Wed, 27 Jun 2012 12:46:24 -0700
Subject: RE: [PATCH 3.5] mwifiex: fix memory leak associated with IE
 manamgement
Message-ID: <477F20668A386D41ADCC57781B1F7043083A97CAC2@SC-VEXCH1.marvell.com> (sfid-20120627_214859_523594_971C28C8)
References: <1340409394-11082-1-git-send-email-bzhao@marvell.com>
In-Reply-To: <1340409394-11082-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: Avinash Patil <patila@marvell.com>
> 
> Free ap_custom_ie before return from function.

Could you apply this patch for 3.5 please?

Thanks,
Bing

> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/ie.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
> index 328fb14..8374e33 100644
> --- a/drivers/net/wireless/mwifiex/ie.c
> +++ b/drivers/net/wireless/mwifiex/ie.c
> @@ -213,6 +213,7 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
>  		/* save assoc resp ie index after auto-indexing */
>  		*assoc_idx = *((u16 *)pos);
> 
> +	kfree(ap_custom_ie);
>  	return ret;
>  }
> 
> --
> 1.7.0.2

