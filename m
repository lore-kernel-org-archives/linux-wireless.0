Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:40883 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750747AbaJKEbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 00:31:20 -0400
Message-ID: <1413001871.8770.52.camel@joe-AO725> (sfid-20141011_063134_946861_E7A32205)
Subject: Re: [PATCH] rtl8732au: Fix coding style violations in ieee80211.h
From: Joe Perches <joe@perches.com>
To: Matthew Tyler <matt.tyler@flashics.com>
Cc: jes.sorensen@redhat.com, linux-wireless@vger.kernel.org
Date: Fri, 10 Oct 2014 21:31:11 -0700
In-Reply-To: <20141011041923.GA9075@ZeroX.Belkin>
References: <20141011041923.GA9075@ZeroX.Belkin>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-10-11 at 12:19 +0800, Matthew Tyler wrote:
> Signed-off-by: Matthew Tyler <matt.tyler@flashics.com>
[]
> diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
[]
> -#define IsSupported24G(NetType) (NetType & SUPPORTED_24G_NETTYPE_MSK ? true : false)
> -#define IsSupported5G(NetType) (NetType & SUPPORTED_5G_NETTYPE_MSK ? true : false)
> +#define IsSupported24G(NetType) \
> +	(NetType & SUPPORTED_24G_NETTYPE_MSK ? true : false)

A lot of these would be better as static inlines or
maybe using !! instead of ternaries.

But it doesn't seem any of these IsSupported<foo> macros
are used at all, so probably deleting is best.

> @@ -266,7 +277,9 @@ join_res:
>  */
>  
>  #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
> -#define MAC_ARG(x) ((u8*)(x))[0],((u8*)(x))[1],((u8*)(x))[2],((u8*)(x))[3],((u8*)(x))[4],((u8*)(x))[5]
> +#define MAC_ARG(x) \
> +	(((u8 *)(x))[0], ((u8 *)(x))[1], ((u8 *)(x))[2], \
> +	 ((u8 *)(x))[3], ((u8 *)(x))[4], ((u8 *)(x))[5])

It'd be better to convert these to use %pM


