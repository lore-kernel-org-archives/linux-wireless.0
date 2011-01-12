Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab1ALMqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:46:05 -0500
Subject: Re: [PATCH 1/2] mac80211: add hw configuration for max ampdu
 buffer size
From: Johannes Berg <johannes@sipsolutions.net>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com
In-Reply-To: <1294836052-16828-1-git-send-email-coelho@ti.com>
References: <1294836052-16828-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 13:46:46 +0100
Message-ID: <1294836406.3639.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 14:40 +0200, coelho@ti.com wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> Some devices don't support the maximum AMDPU buffer size of 64, so we
> need to add an option to configure this in the hardware configuration.
> This value will be used in the ADDBA response instead of the value
> suggested in the request, if the latter is greater than the max
> supported.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  include/net/mac80211.h |    4 ++++
>  net/mac80211/agg-rx.c  |    3 +++
>  net/mac80211/main.c    |    1 +
>  3 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5b3fd5a..1341d82 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1143,6 +1143,9 @@ enum ieee80211_hw_flags {
>   * @napi_weight: weight used for NAPI polling.  You must specify an
>   *	appropriate value here if a napi_poll operation is provided
>   *	by your driver.
> + * @max_rx_aggregation_subframes: maximum buffer size (number of
> + *	sub-frames) to be used for A-MPDU block ack receiver
> + *	aggregation.

... "This is only relevant if the device has restrictions on the number
of subframes, if it relies on mac80211 to do reordering it shouldn't be
set." maybe?

johannes

