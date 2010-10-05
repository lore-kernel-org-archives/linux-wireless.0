Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:22539 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0JELSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 07:18:31 -0400
Subject: Re: [PATCH v3 0/3] wl1271: Packet aggregation optimizations
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <1285853308-24290-1-git-send-email-ido@wizery.com>
References: <1285853308-24290-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:18:06 +0300
Message-ID: <1286277486.15401.8.camel@chilepepper>
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
> 
> Ido Yariv (3):
>   wl1271: Handle large SPI transfers
>   wl1271: Support firmware RX packet aggregation
>   wl1271: Support firmware TX packet aggregation
> 
>  drivers/net/wireless/wl12xx/wl1271.h      |    5 +
>  drivers/net/wireless/wl12xx/wl1271_main.c |   15 +++-
>  drivers/net/wireless/wl12xx/wl1271_rx.c   |   63 ++++++++++----
>  drivers/net/wireless/wl12xx/wl1271_spi.c  |  140 ++++++++++++++++++-----------
>  drivers/net/wireless/wl12xx/wl1271_tx.c   |   99 ++++++++-------------
>  5 files changed, 189 insertions(+), 133 deletions(-)
> 

Thanks, applied to the wl12xx tree, master branch.


-- 
Cheers,
Luca.

