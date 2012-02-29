Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:49871 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2B2IJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:09:38 -0500
Message-ID: <20120229100932.97454g5f6tjgmx44@www.81.fi> (sfid-20120229_090942_027876_8DA1680A)
Date: Wed, 29 Feb 2012 10:09:32 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: re: rndis_wlan: split getting current channel to separate function
References: <20120229063234.GB18031@elgon.mountain>
In-Reply-To: <20120229063234.GB18031@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> Hello Jussi,
>
> The patch b5257c952: "rndis_wlan: workaround device not returning bss
> for currently connected AP" from Nov 9, 2011, leads to the following
> warning:
> drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast to restricted __le16
> drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast from  
> restricted __le32
>
>   1372
>   1373          if (beacon_interval)
>   1374                  *beacon_interval = le16_to_cpu(config.beacon_period);
>   1375          return channel;
>
> The problem is that config.beacon_period is declared as le32 but we're
> using it as le16.

Ah yes, I'll post patch soon. Thanks.

-Jussi

>
> regards,
> dan carpenter
>
>
>



