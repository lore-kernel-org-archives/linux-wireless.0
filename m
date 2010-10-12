Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:29272 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab0JLMCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:02:15 -0400
Subject: Re: [PATCH v2 4/4] wl1271: Fix TX queue low watermark handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286873633-10080-5-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
	 <1286873633-10080-5-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 15:01:50 +0300
Message-ID: <1286884910.11177.515.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 10:53 +0200, ext Ido Yariv wrote:
> The number of entries in the TX queue is compared to the low watermark
> value each time TX completion interrupts are handled.
> However, the fact that a TX completion arrived does not necessarily mean
> there are any less skbs in the TX queue.
> 
> In addition, a TX completion interrupt does not necessarily mean that there
> are any new available TX blocks. Thus, queuing TX work when the low
> watermark is reached might not be needed.
> 
> Fix this by moving the low watermark handling to the TX work function,
> and avoid queuing TX work in this case.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_tx.c |   35 +++++++++++++++++++-----------
>  1 files changed, 22 insertions(+), 13 deletions(-)
> 

This really could improve TX performance slightly - it allows the
mac80211 to start tx'ing packets more aggressively after the driver
buffer has reached the low watermark. The tx-pipeline will be constantly
filled.

Good work. Thanks for these patches!

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

