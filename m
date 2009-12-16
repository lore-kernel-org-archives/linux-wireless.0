Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39592 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZLPOxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 09:53:19 -0500
Subject: Re: [PATCH] iwmc3200wifi: Fix test of unsigned in
 iwm_ntf_stop_resume_tx()
From: Pavel Roskin <proski@gnu.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B28DBB6.5030304@gmail.com>
References: <4B28DBB6.5030304@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 09:53:15 -0500
Message-Id: <1260975195.2965.3.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-16 at 14:08 +0100, Roel Kluin wrote:
> `queue' is unsigned so the test did not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
> index 1c57c1f..9ac72e4 100644
> --- a/drivers/net/wireless/iwmc3200wifi/rx.c
> +++ b/drivers/net/wireless/iwmc3200wifi/rx.c
> @@ -1128,7 +1128,7 @@ static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
>  			struct iwm_tx_queue *txq;
>  			u16 queue = iwm_tid_to_queue(bit);
>  
> -			if (queue < 0)
> +			if (queue == -EINVAL)

I think it's ugly.  iwm_tid_to_queue() should return int if it's allowed
to return error codes.

-- 
Regards,
Pavel Roskin
