Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab0JLMCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:02:07 -0400
Subject: Re: [PATCH v2 3/4] wl1271: Allocate TX descriptors more efficiently
From: Johannes Berg <johannes@sipsolutions.net>
To: Ido Yariv <ido@wizery.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1286873633-10080-4-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
	 <1286873633-10080-4-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:02:01 +0200
Message-ID: <1286884921.3753.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 10:53 +0200, Ido Yariv wrote:
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
> diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> index 4a034a3..ddecc96 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -398,6 +398,7 @@ struct wl1271 {
>  	struct work_struct tx_work;
>  
>  	/* Pending TX frames */
> +	unsigned long tx_frames_map;
>  	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];

Just use
	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
instead and you don't have to worry about the number anywhere.

johannes

