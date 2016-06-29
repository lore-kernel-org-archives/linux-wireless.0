Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcF2QBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 12:01:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: include also core.h header in cfg80211.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466268596-12178-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160629160114.BA16461388@smtp.codeaurora.org> (sfid-20160629_180144_583225_EF4EB895)
Date: Wed, 29 Jun 2016 16:01:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> This header provides two inline functions using struct brcmf_if so we
> need core.h to avoid:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h: In function ‘ndev_to_prof’:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:368:13: error: dereferencing pointer to incomplete type
>   return &ifp->vif->profile;
>              ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h: In function ‘ndev_to_vif’:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:374:12: error: dereferencing pointer to incomplete type
>   return ifp->vif;
>             ^
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

bda9d01427f5 brcmfmac: include also core.h header in cfg80211.h

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9185755/

