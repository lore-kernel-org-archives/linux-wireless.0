Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1NPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:15:17 -0400
Date: Fri, 28 Mar 2014 09:07:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fariya Fatima <fariyaf@gmail.com>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] rsi: rsi_91x: misleading debug printk
Message-ID: <20140328130748.GJ31168@tuxdriver.com> (sfid-20140328_141524_556634_32AD6B8B)
References: <20140328082733.GK25192@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140328082733.GK25192@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

;-)

goto fail;
goto fail;

Thanks, Dan!

On Fri, Mar 28, 2014 at 11:27:33AM +0300, Dan Carpenter wrote:
> There is a missing set of curly braces here so the debug output says
> "Probe confirm received" unintentionally.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> index ef37d4b..2361a68 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> @@ -1292,10 +1292,11 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
>  			return -EINVAL;
>  		}
>  	} else if (msg_type == TX_STATUS_IND) {
> -		if (msg[15] == PROBEREQ_CONFIRM)
> +		if (msg[15] == PROBEREQ_CONFIRM) {
>  			common->mgmt_q_block = false;
>  			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
>  				__func__);
> +		}
>  	} else {
>  		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
>  	}
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
