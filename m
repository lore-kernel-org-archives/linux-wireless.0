Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39115 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbcF2Pl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:41:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: slightly simplify building interface combinations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465326626-365-1-git-send-email-zajec5@gmail.com>
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
Message-Id: <20160629154152.8E340613A6@smtp.codeaurora.org> (sfid-20160629_174228_391446_CE2461C2)
Date: Wed, 29 Jun 2016 15:41:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> This change reorders some operations in brcmf_setup_ifmodes in hope to
> make it simpler:
> 1) It allocates arrays right before filling them. This way it's easier
>    to follow requested array length as it's immediately followed by
>    code filling it. It's easier to check e.g. why we need 4 entries for
>    P2P. Other than that it deduplicates some checks (e.g. for P2P).
> 2) It reorders code to first prepare limits and then define a new combo.
>    Previously this was mixed (e.g. we were setting num of channels
>    before preparing limits).
> 3) It modifies mbss code to use i variable just like other combos do.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

f568adac7d1a brcmfmac: slightly simplify building interface combinations

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9162267/

