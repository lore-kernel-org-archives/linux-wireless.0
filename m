Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2IJQhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 12:37:54 -0400
Received: by eaac11 with SMTP id c11so1007453eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 09:37:53 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 03/10] brcmfmac: Fix extra data support handling.
Date: Mon, 10 Sep 2012 18:37:09 +0200
Message-ID: <5221312.fK3dkv1oOA@flexo> (sfid-20120910_183758_342737_6B8471C0)
In-Reply-To: <1347283018-24223-4-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com> <1347283018-24223-4-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday 10 September 2012 15:16:51 Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
> 
> This patch fixes bug in length calculation.
> 
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c 
b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index 6383052..4553fa0 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -3331,7 +3331,7 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, 
u32 event,
>  
>  	total_len = sizeof(struct brcmf_cfg80211_event_q);
>  	if (data)
> -		data_len += be32_to_cpu(msg->datalen);
> +		data_len = be32_to_cpu(msg->datalen);

This should be folded in patch 2/10 since this is where the bug gets 
introduced.
--
Florian
