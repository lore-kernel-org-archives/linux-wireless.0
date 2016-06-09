Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60453 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbcFIQRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 12:17:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: rework function picking free BSS index
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464219876-13776-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160609161732.90E20613F6@smtp.codeaurora.org> (sfid-20160609_181755_531976_DA1E3C3F)
Date: Thu,  9 Jun 2016 16:17:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> The old implementation was overcomplicated and slightly bugged in some
> corner cases.
> 
> Consider following state of BSS-es (limited to 6 for simplification):
> drvr->iflist[0]: { bsscfgidx:0, ndev->name:wlan1, }
> drvr->iflist[1]:  (null)
> drvr->iflist[2]: { bsscfgidx:2, ndev->name:wlan1-1, }
> drvr->iflist[3]: { bsscfgidx:3, ndev->name:wlan1-2, }
> drvr->iflist[4]:  (null)
> drvr->iflist[5]:  (null)
> In such case the next AP interface should bsscfgidx 4 (we don't use 1 as
> it's reserved for P2P).
> 
> With old code the loop iterations were following:
> [ifidx = 0] [bsscfgidx = 2] [highest = 2]
> [ifidx = 1] [bsscfgidx = 2] [highest = 2] available = true
> [ifidx = 2] [bsscfgidx = 2] [highest = 2] bsscfgidx = highest + 1
> [ifidx = 3] [bsscfgidx = 3] [highest = 2] bsscfgidx = highest + 1
> [ifidx = 4] [bsscfgidx = 3] [highest = 2] available = true
> [ifidx = 5] [bsscfgidx = 3] [highest = 2] available = true
> There were 2 obvious problems:
> 1) Having empty BSS at index 1 was resulting in available being always
>    set to true, even if we would run out of BSS-es.
> 2) Calculated bsscfgidx was invalid (3 instead of 4) resulting in driver
>    not being able to create the 4th AP interface.
> 
> New code is simpler, placed in file where it's really used, handles
> running out of free BSS-es and allows using 4 interfaces at the same
> time. It also looks for the first free BSS instead of one after the last
> in use. It works well with current driver (which doesn't allow deleting
> interfaces) and should be future proof (if we ever allow deleting).
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

d02fb8f14b2d brcmfmac: rework function picking free BSS index

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9136421/

