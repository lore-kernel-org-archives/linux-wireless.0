Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:47340 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdFOR3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:29:07 -0400
Date: Thu, 15 Jun 2017 10:29:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: nci: remove unnecessary null check
Message-ID: <20170615172903.GD7549@roeck-us.net> (sfid-20170615_192933_365190_F1DC6811)
References: <28317503-e721-2564-a9ff-82182aa0644a@roeck-us.net>
 <20170613163718.GA5375@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170613163718.GA5375@embeddedgus>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 13, 2017 at 11:37:18AM -0500, Gustavo A. R. Silva wrote:
> Remove unnecessary NULL check for pointer conn_info.
> conn_info is set in list_for_each_entry() using container_of(),
> which is never NULL.
> 
> Addresses-Coverity-ID: 1362349
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  net/nfc/nci/core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 61fff42..c15cb88 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -73,11 +73,10 @@ int nci_get_conn_info_by_dest_type_params(struct nci_dev *ndev, u8 dest_type,
>  		if (conn_info->dest_type == dest_type) {
>  			if (!params)
>  				return conn_info->conn_id;
> -			if (conn_info) {
> -				if (params->id == conn_info->dest_params->id &&
> -				    params->protocol == conn_info->dest_params->protocol)
> -					return conn_info->conn_id;
> -			}
> +
> +			if (params->id == conn_info->dest_params->id &&
> +			    params->protocol == conn_info->dest_params->protocol)
> +				return conn_info->conn_id;
>  		}
>  	}
>  
> -- 
> 2.5.0
> 
