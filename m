Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565Ab3FMJxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 05:53:44 -0400
Message-ID: <1371117219.8335.9.camel@jlt4.sipsolutions.net> (sfid-20130613_115351_558886_AEDA67CD)
Subject: Re: [PATCH v2 1/2] mac80211: move tx_control_flag into flags2
 within ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name
Date: Thu, 13 Jun 2013 11:53:39 +0200
In-Reply-To: <1371112067-19239-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1371112067-19239-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-13 at 10:27 +0200, Thomas Huehn wrote:


> Flag IEEE80211_TX_CTL_REQ_TX_STATUS at bit(0) in
> mac80211_tx_control_flags
> is moved to ieee80211_tx_info->control.flags2 as it is only used in
> the
> tx-path. This frees one bit in ieee80211_tx_info->flags.

I'm sure some drivers use it in their status path. Have you audited them
all?

No, you clearly haven't. carl9170 is *obviously* broken by this change,
others may not so obvious.

>  		} else if ((txinfo->flags & IEEE80211_TX_STAT_ACK) &&
> -			   !(txinfo->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
> +			   !(txinfo->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS)) {

I bet you did some sort of automatic replace, but these lines look far
too long.

Also, if you're doing hugely invasive patches like this then I think you
should move more flags and be done with it.

> @@ -1561,7 +1561,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
>  			 u16 transaction, u16 auth_alg, u16 status,
>  			 const u8 *extra, size_t extra_len, const u8 *bssid,
>  			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx,
> -			 u32 tx_flags);
> +			 u32 tx_flags, u16 tx_flags2);

This function already has far too many arguments, I'm not taking a patch
adding yet another one.

Please repost only when you've actually checked what you're doing.

johannes

