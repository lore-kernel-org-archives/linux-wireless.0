Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57672 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbcFPPMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:12:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,
 next] brcmfmac: don't remove interface on link down firmware event
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464583269-30255-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160616151252.30C226141A@smtp.codeaurora.org> (sfid-20160616_171301_734081_A4B001D4)
Date: Thu, 16 Jun 2016 15:12:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> There are two firmware events we handle similarly in brcmfmac:
> BRCMF_E_LINK and BRCMF_E_IF. The difference from firmware point of view
> is that the first one means BSS remains present in the firmware. Trying
> to (re)create it (e.g. when adding new virtual interface) will result in
> an error.
> 
> Current code treats both events in a similar way. It removes Linux
> interface for each of them. It works OK with e.g. BCM43602. Its firmware
> generates both events for each interface. It means we get BRCMF_E_LINK
> and remove interface. That is soon followed by BRCMF_E_IF which means
> BSS was also removed in a firmware. The only downside of this is a
> harmless error like:
> [  208.643180] brcmfmac: brcmf_fweh_call_event_handler: no interface object
> 
> Unfortunately BCM4366 firmware doesn't automatically remove BSS and so
> it doesn't generate BRCMF_E_IF. In such case we incorrectly remove Linux
> interface on BRCMF_E_LINK as BSS is still present in the firmware. It
> results in an error when trying to re-create virtual interface, e.g.:
> > iw phy phy1 interface add wlan1-1 type __ap
> [ 3602.929199] brcmfmac: brcmf_ap_add_vif: timeout occurred
> command failed: I/O error (-5)
> 
> With this patch we don't remove Linux interface while firmware keeps
> BSS. Thanks to this we keep a consistent states of host driver and
> device firmware.
> 
> Further improvement should be to mark BSS as disabled and remove
> interface on BRCMF_E_LINK. Then we should add support for reusing
> BSS-es.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

fd3667a8d1cb brcmfmac: don't remove interface on link down firmware event

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9140237/

