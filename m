Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46607 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaDBTYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 15:24:14 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so7810488wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2014 12:24:13 -0700 (PDT)
Message-ID: <533C63D6.5000109@gmail.com> (sfid-20140402_212419_187450_1466B0AE)
Date: Wed, 02 Apr 2014 20:24:06 +0100
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrea Merello <andrea.merello@gmail.com>,
	dan.carpenter@oracle.com, linville@tuxdriver.com
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8180: don't use weird trick to access "far" registers
References: <20140328093038.GD7045@mwanda> <1396026868-5622-1-git-send-email-andrea.merello@gmail.com>
In-Reply-To: <1396026868-5622-1-git-send-email-andrea.merello@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28/03/2014 17:14, Andrea Merello wrote:
> @@ -340,9 +334,9 @@ struct rtl818x_csr {
>    * I don't like to introduce a ton of "reserved"..
>    * They are for RTL8187SE
>    */
> -#define REG_ADDR1(addr)	((u8 __iomem *)(&priv->map->offset1[(addr)]))
> -#define REG_ADDR2(addr)	((__le16 __iomem *)(&priv->map->offset2[((addr) >> 1)]))
> -#define REG_ADDR4(addr)	((__le32 __iomem *)(&priv->map->offset4[((addr) >> 2)]))
> +#define REG_ADDR1(addr)	((u8 __iomem *)priv->map + addr)
> +#define REG_ADDR2(addr)	((__le16 __iomem *)priv->map + (addr >> 1))
> +#define REG_ADDR4(addr)	((__le32 __iomem *)priv->map + (addr >> 2))
>   
>   #define FEMR_SE		REG_ADDR2(0x1D4)
>   #define ARFR		REG_ADDR2(0x1E0)
I suggest parenthesizing the use of addr in your macros (as the original 
code does), to avoid any issues with operator precedence wrt >>.

If the removal was intentional and you've verified there's no issues, 
you should probably mention it in the commit message.


Dave.
