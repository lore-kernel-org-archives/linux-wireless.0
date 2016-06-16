Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57134 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcFPPHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:07:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] brcmfmac: fix setting AP channel with new firmwares
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464376045-8220-1-git-send-email-zajec5@gmail.com>
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
Message-Id: <20160616150733.8C8546141F@smtp.codeaurora.org> (sfid-20160616_170800_683466_5170DC45)
Date: Thu, 16 Jun 2016 15:07:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> Firmware for new chipsets is based on a new major version of code
> internally maintained at Broadcom. E.g. brcmfmac4366b-pcie.bin (used for
> BCM4366B1) is based on 10.10.69.3309 while brcmfmac43602-pcie.ap.bin was
> based on 7.35.177.56.
> 
> Currently setting AP 5 GHz channel doesn't work reliably with BCM4366B1.
> When setting e.g. 36 control channel with VHT80 (center channel 42)
> firmware may randomly pick one of:
> 1) 52 control channel with 58 as center one
> 2) 100 control channel with 106 as center one
> 3) 116 control channel with 122 as center one
> 4) 149 control channel with 155 as center one
> 
> It seems new firmwares require setting AP mode (BRCMF_C_SET_AP) before
> specifying a channel. Changing an order of firmware calls fixes the
> problem. This requirement resulted in two separated "chanspec" calls,
> one in AP code path and one in P2P path.
> 
> This fix was verified with BCM4366B1 and tested for regressions on
> BCM43602.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

8707e08dbc1f brcmfmac: fix setting AP channel with new firmwares

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9138883/

