Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40430 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbcF2P6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:58:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [REBASED] brcmfmac: fix lockup when removing P2P interface after
 event timeout
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466159371-19968-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160629155757.4250E61372@smtp.codeaurora.org> (sfid-20160629_175912_869437_BC77AC57)
Date: Wed, 29 Jun 2016 15:57:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> Removing P2P interface is handled by sending a proper request to the
> firmware. On success firmware triggers an event and driver's handler
> removes a matching interface.
> 
> However on event timeout we remove interface directly from the cfg80211
> callback. Current code doesn't handle this case correctly as it always
> assumes rtnl to be unlocked.
> 
> Fix it by adding an extra rtnl_locked parameter to functions and calling
> unregister_netdevice when needed.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

b50ddfa8530e brcmfmac: fix lockup when removing P2P interface after event timeout

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9183337/

