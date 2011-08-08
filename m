Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1HHIuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:50:46 -0400
Subject: Re: [PATCH 1/2] mac80211: Stop TX BA session if buf_size is zero
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110726_121902_594343_0F5FD36E)
References: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110726_121902_594343_0F5FD36E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:50:42 +0200
Message-ID: <1312793442.4372.12.camel@jlt3.sipsolutions.net> (sfid-20110808_105102_478828_FEDF2705)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-26 at 12:18 +0200, Helmut Schaa wrote:
> If we receive an ADDBA response with status code 0 and a buf_size of 0
> we should stop the TX BA session as otherwise we'll end up queuing
> frames in ieee80211_tx_prep_agg forever instead of sending them out as
> non AMPDUs.
> 
> This fixes a problem with AVM Fritz Stick N wireless devices where
> frames to this device are not transmitted anymore by mac80211.

I guess this is acceptable since it shouldn't be happening anyway.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  net/mac80211/agg-tx.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index c8be8ef..b7075f3 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -777,18 +777,14 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>  	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
>  #endif
> -
> +	/*
> +	 * IEEE 802.11-2007 7.3.1.14:
> +	 * In an ADDBA Response frame, when the Status Code field
> +	 * is set to 0, the Buffer Size subfield is set to a value
> +	 * of at least 1.
> +	 */
>  	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
> -			== WLAN_STATUS_SUCCESS) {
> -		/*
> -		 * IEEE 802.11-2007 7.3.1.14:
> -		 * In an ADDBA Response frame, when the Status Code field
> -		 * is set to 0, the Buffer Size subfield is set to a value
> -		 * of at least 1.
> -		 */
> -		if (!buf_size)
> -			goto out;
> -
> +			== WLAN_STATUS_SUCCESS && buf_size) {
>  		if (test_and_set_bit(HT_AGG_STATE_RESPONSE_RECEIVED,
>  				     &tid_tx->state)) {
>  			/* ignore duplicate response */


