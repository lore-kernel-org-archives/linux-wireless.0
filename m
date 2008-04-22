Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046AbYDVUvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 16:51:10 -0400
Message-ID: <480E4FC2.5080909@trash.net> (sfid-20080422_225155_927768_84AEB6ED)
Date: Tue, 22 Apr 2008 22:51:14 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	Dan Williams <dcbw@redhat.com>,
	Roy Marples <uberlord@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: prism54 regression in current -git
References: <480D6CA4.8040205@trash.net> <1208874998.17364.7.camel@localhost.localdomain> <480DFCB4.3040104@trash.net> <43e72e890804221050i47ba5974i59d89cde55645f4@mail.gmail.com> <20080422180332.GD4810@ruslug.rutgers.edu>
In-Reply-To: <20080422180332.GD4810@ruslug.rutgers.edu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
>> Good catch. The carrier is set upon a firmware trigger so it is
>> possible that when in AP mode we don't hit the trigger in firmware. I
>> left open the possibility for this happening and go figure it happens.
>> Even if we had docs this probably wouldn't be documented :) I'll try
>> to cook up an exception patch now.
> 
> Let me know if this fixes it.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
> index 04c2638..9196825 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.c
> +++ b/drivers/net/wireless/prism54/islpci_dev.c
> @@ -388,8 +388,15 @@ islpci_open(struct net_device *ndev)
>  
>  	netif_start_queue(ndev);
>  
> -	/* Turn off carrier unless we know we have associated */
> -	netif_carrier_off(ndev);
> +	/* Turn off carrier if in STA or Ad-hoc mode. It will be turned on
> +	 * once the firmware receives a trap of being associated
> +	 * (GEN_OID_LINKSTATE). In other modes (AP or WDS or monitor) we
> +	 * should just leave the carrier on as its expected the firmware
> +	 * won't send us a trigger. */
> +	if (priv->iw_mode == IW_MODE_INFRA || priv->iw_mode == IW_MODE_ADHOC)
> +		netif_carrier_off(ndev);
> +	else
> +		netif_carrier_on(ndev);
>  
>  	return 0;
>  }
> 

This will probably fix the error I'm seeing, but if I'm not
mistaken the mode can be changed while the device is UP and
this case is not handled by your patch.
