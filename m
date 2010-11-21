Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2807 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab0KUI66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 03:58:58 -0500
Message-ID: <4CE8DF4F.5050803@gmail.com>
Date: Sun, 21 Nov 2010 09:58:55 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/62] rt2x00: Use static const
References: <cover.1290305773.git.joe@perches.com> <d8bfaded20da2265673391a81536d63b0e81dc7f.1290305776.git.joe@perches.com>
In-Reply-To: <d8bfaded20da2265673391a81536d63b0e81dc7f.1290305776.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/10 03:39, Joe Perches wrote:
> Using static const generally increases object text and decreases data size.
> It also generally decreases overall object size.
> 
>    text	   data	    bss	    dec	    hex	filename
>   40197	     56	   8336	  48589	   bdcd	drivers/net/wireless/rt2x00/rt2800lib.o.new
>   40205	     56	   8336	  48597	   bdd5	drivers/net/wireless/rt2x00/rt2800lib.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For rt2x00 this is just a tiny optimization, but for what it's worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index ce8df66..7563161 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2166,7 +2166,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  					 SHARED_KEY_MODE_ENTRY(i), 0);
>  
>  	for (i = 0; i < 256; i++) {
> -		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
> +		static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
>  		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
>  					      wcid, sizeof(wcid));
>  

