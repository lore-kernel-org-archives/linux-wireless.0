Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:49150 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab0JLL5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 07:57:30 -0400
Subject: Re: [PATCH v2 3/4] wl1271: Allocate TX descriptors more efficiently
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286873633-10080-4-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
	 <1286873633-10080-4-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:57:06 +0300
Message-ID: <1286884626.11177.512.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 10:53 +0200, ext Ido Yariv wrote:
> On each TX descriptor allocation, a free entry is found by traversing the TX
> descriptors array.
> 
> Improve this by holding a bitmap of all TX descriptors, and using efficient
> bit operations to search for free entries.
> The bitmap is 32 bits long, assuming that the maximum number of
> descriptors (ACX_TX_DESCRIPTORS) will never exceed 32.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h      |    1 +
>  drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
>  drivers/net/wireless/wl12xx/wl1271_tx.c   |   38 ++++++++++++++++------------
>  3 files changed, 24 insertions(+), 16 deletions(-)
> 

I doubt this will have any performance impact, but indeed it is a bit
cleaner this way.

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

