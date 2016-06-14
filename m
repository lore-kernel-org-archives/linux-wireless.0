Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60158 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbcFNO2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:28:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2, 4.8,
 1/2] brcmutil: add field storing control channel to the struct
 brcmu_chan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463744355-5528-1-git-send-email-zajec5@gmail.com>
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
Message-Id: <20160614142819.8522261381@smtp.codeaurora.org> (sfid-20160614_162847_662946_1D724418)
Date: Tue, 14 Jun 2016 14:28:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> Our d11 code supports encoding/decoding channel info into/from chanspec
> format used by firmware. Current implementation is quite misleading
> because of the way "chnum" field is used.
> When encoding channel info, "chnum" has to be filled by a caller with
> *center* channel number. However when decoding chanspec the same field
> is filled with a *control* channel number.
> 
> 1) This can be confusing. It's expected for information to be the same
>    after encoding and decoding.
> 2) It doesn't allow accessing all info when decoding. Some functions may
>    need to know both channel numbers, e.g. cfg80211 callback getting
>    current channel.
> Solve this by adding a separated field for control channel.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

4712d88a5732 brcmutil: add field storing control channel to the struct brcmu_chan
ee6e7aa38394 brcmfmac: support get_channel cfg80211 callback

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9129323/

