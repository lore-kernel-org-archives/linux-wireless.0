Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43782 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0I3IXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 04:23:19 -0400
Subject: Re: [PATCH v2 0/3] wl1271: Packet aggregation optimizations
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <1285834259-3178-1-git-send-email-ido@wizery.com>
References: <1285834259-3178-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 11:22:59 +0300
Message-ID: <1285834979.11177.158.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 10:10 +0200, ext Ido Yariv wrote:
> The WL1271 HW supports sending and receiving multiple packets within
> a single transaction. This can substantially reduce CPU usage and
> increase network throughput.
> 
> The following patches add support for RX and TX packet aggregation.
> An opportunistic approach was taken - all packets that are currently
> available for sending/receiving are aggregated and transferred
> in a single transaction.
> 
> On SPI platforms, tests done by Juuso Oikarinen have shown a 20% improvement
> in CPU usage.
> On SDIO platforms, some tests have shown an improvement of over 30% in CPU
> usage.
> 
> Changes since v1:
> The SPI callbacks do not handle large transfers well. The first patch fixes
> this by fragmenting large transfers into smaller ones.
> 
> Thanks Juuso Oikarinen for reporting the SPI issue and helping with testing
> and benchmarking these optimizations.
> 
> Ido Yariv (3):
>   wl1271: Handle large SPI transfers
>   wl1271: Support firmware RX packet aggregation
>   wl1271: Support firmware TX packet aggregation
> 

Thanks for your effort! I have tested these patches on our platforms
(both SPI and SDIO.) The patches seem to work, and they appear to indeed
deliver the performance improvement mentioned:

Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

