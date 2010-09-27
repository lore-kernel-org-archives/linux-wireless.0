Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab0I0JM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 05:12:59 -0400
Subject: Re: [PATCH 16/25] wl1271: Add support for hardware GEM cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1285576669-8070-17-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-17-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 11:12:57 +0200
Message-ID: <1285578777.4043.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> This patch adds support for the hardware GEM cipher suite.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h      |    2 ++
>  drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_main.c |   16 ++++++++++++++++
>  3 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> index 763ece8..9782bc1 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -117,6 +117,8 @@ enum {
>  #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
>  #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
>  
> +#define WL1271_CIPHER_SUITE_GEM 0x000FACFF

NACK, this is a standards-reserved value. Use the correct ID for it or
allocate one within your own OUI if you don't want to admit what this
really is (and by now all readers here will know anyway.)

johannes


