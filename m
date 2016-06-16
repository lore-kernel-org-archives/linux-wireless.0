Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59557 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbcFPP0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:26:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: include required headers in cfg80211.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465280428-5782-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160616152652.ED17F61418@smtp.codeaurora.org> (sfid-20160616_172716_973519_8243D809)
Date: Thu, 16 Jun 2016 15:26:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> Without this including cfg80211.h in a wrong order could result in:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:122:24: error: array type has incomplete element type
>   struct brcmf_wsec_key key[BRCMF_MAX_DEFAULT_KEYS];
>                         ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:291:24: error: field ‘p2p’ has incomplete type
>   struct brcmf_p2p_info p2p;
>                         ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:297:27: error: field ‘pmk_list’ has incomplete type
>   struct brcmf_pmk_list_le pmk_list;
>                            ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h:317:28: error: field ‘assoclist’ has incomplete type
>   struct brcmf_assoclist_le assoclist;
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

29477269a27d brcmfmac: include required headers in cfg80211.h

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9159889/

