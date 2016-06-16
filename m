Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57452 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbcFPPKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:10:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.7 FIX] brcmfmac: fix lockup when removing P2P interface after event timeout
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
Date: Thu, 16 Jun 2016 18:10:35 +0300
In-Reply-To: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 27 May 2016
 21:53:14 +0200")
Message-ID: <877fdpw4no.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_171118_160544_BE11F0ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

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

Failed to apply, please rebase:

Applying: brcmfmac: fix lockup when removing P2P interface after event timeout
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
Failed to merge in the changes.
Patch failed at 0001 brcmfmac: fix lockup when removing P2P interface after event timeout

-- 
Kalle Valo
