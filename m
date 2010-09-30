Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42944 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0I3TZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 15:25:09 -0400
Subject: Re: [PATCH v3 0/3] wl1271: Packet aggregation optimizations
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <1285853308-24290-1-git-send-email-ido@wizery.com>
References: <1285853308-24290-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 22:24:58 +0300
Message-ID: <1285874698.1578.9.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 15:28 +0200, ext Ido Yariv wrote:
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
> Changes since v2:
> Fix debug output in the SPI callbacks.
> 
> Changes since v1:
> The SPI callbacks do not handle large transfers well. The first patch fixes
> this by fragmenting large transfers into smaller ones.
> 
> Thanks Juuso Oikarinen for reporting the SPI issue and helping with testing
> and benchmarking these optimizations.

This looks very good.  Thanks for your work and thanks Juuso for the
tests and verification.

I'll apply this as soon as John pulls our wl12xx tree, so we can keep it
linear.

-- 
Cheers,
Luca.

