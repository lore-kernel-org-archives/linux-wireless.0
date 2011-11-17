Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44092 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1KQPOB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 10:14:01 -0500
Message-ID: <4EC524B1.2070200@openwrt.org> (sfid-20111117_161409_090581_13775D25)
Date: Thu, 17 Nov 2011 16:13:53 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Daniel Kuehn <daniel@kuehn.se>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] Seeing as alot of ath9k devices is PCI/PCIe or their
 mini equivalent it makes sense to set ATH9K_PCI to y by default
References: <20111109235757.79821a20@Artemis>
In-Reply-To: <20111109235757.79821a20@Artemis>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011.11.09. 23:57 keltezéssel, Daniel Kuehn írta:
> from: Daniel Kuehn <daniel@kuehn.se>
> 
> Most ath9k devices are PCI/PCIe based, therefor making PCI/PCIe support
> default y helps those porting a config from 2.6 kernel series
> from getting "non-functional" wireless drivers with 3.x kernel series.
> 
> Signed-off-by: Daniel Kuehn <daniel@kuehn.se>

The option was enabled in the past but it has been removed a few months ago by
the following commit:

commit 64bd0821a3b66c3307d7a4ee5523e3e35ec2df0e
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Wed May 25 09:44:05 2011 +0800

    wireless: Default to 'n' for 2 new added devices in Kconfig.

    We make oldconfig every time when a new kernel arrives, but
    if we don't have such a device(I guess this is the most common
    case for a new device), the default value should be 'n' so
    that the kernel size we build doesn't grow up too much quickly.
    For anyone who has the device, it is OK for them to turn it on
    by themselves.

    Cc: "John W. Linville" <linville@tuxdriver.com>
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


In my opinion it should not be added again.

Regards,
Gabor
