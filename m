Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeELIkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:40:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,
 1/2] Revert "ssb: Prevent build of PCI host features in module"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180511091715.1989-1-zajec5@gmail.com>
References: <20180511091715.1989-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180512084011.DEA1360807@smtp.codeaurora.org> (sfid-20180512_104024_445573_04B699E5)
Date: Sat, 12 May 2018 08:40:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
> 
> Above commit added "SSB = y" dependency to the wrong symbol
> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
> selected when needed. PCI core driver for core running in clienthost
> mode is important for bus initialization. It's perfectly valid scenario
> to have ssb built as module and use it with buses on PCI cards.
> 
> This fixes regression that affected all *module* users with PCI cards.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1572349
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers.git, thanks.

36910d82a80c Revert "ssb: Prevent build of PCI host features in module"
ebd27d3317c6 ssb: make SSB_PCICORE_HOSTMODE depend on SSB = y

-- 
https://patchwork.kernel.org/patch/10393729/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
