Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36018 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbLURxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 12:53:31 -0500
Received: by mail-qg0-f49.google.com with SMTP id c96so92340687qgd.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 09:53:30 -0800 (PST)
Subject: Re: [PATCH] enable setting MAC address for r8723au
To: Dan Lenski <dlenski@gmail.com>, linux-wireless@vger.kernel.org
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
 <1450664916-25205-2-git-send-email-dlenski@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56783C98.1080700@lwfinger.net> (sfid-20151221_185334_892312_81F3953F)
Date: Mon, 21 Dec 2015 11:53:28 -0600
MIME-Version: 1.0
In-Reply-To: <1450664916-25205-2-git-send-email-dlenski@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2015 08:28 PM, Dan Lenski wrote:
> Signed-off-by: Dan Lenski <dlenski@gmail.com>

The commit message should be in this patch rather than in the non-patch previous 
mail. If this patch were to be accepted, all that explanation would be lost!

Rather than issuing a warning when the MAC is changed after the interface has 
been brought up, have you considered changing the value of rtw_adapter->bup to 
zero whenever the connection goes down? Would that help with the confusion in 
the user-space tools?

NACK.


Larry

> ---
>   drivers/staging/rtl8723au/os_dep/os_intfs.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> index b8848c2..228e19f 100644
> --- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> @@ -240,8 +240,11 @@ static int rtw_net_set_mac_address(struct net_device *pnetdev, void *p)
>   	struct rtw_adapter *padapter = netdev_priv(pnetdev);
>   	struct sockaddr *addr = p;
>
> -	if (!padapter->bup)
> -		ether_addr_copy(padapter->eeprompriv.mac_addr, addr->sa_data);
> +	if (padapter->bup)
> +		DBG_8723A_LEVEL(_drv_warning_, "Trying to set MAC address while bup =%d\n", padapter->bup);
> +	ether_addr_copy(padapter->eeprompriv.mac_addr, addr->sa_data);
> +	ether_addr_copy(pnetdev->dev_addr, addr->sa_data);
> +
>   	return 0;
>   }
>
>

