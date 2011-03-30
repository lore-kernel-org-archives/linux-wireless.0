Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1C3IMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 04:12:37 -0400
Subject: Re: [PATCH v5 08/10] nl80211: New notification to discover mesh
 peer candidates.
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301450767-27045-9-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
	 <1301450767-27045-9-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 10:12:34 +0200
Message-ID: <1301472754.3935.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-29 at 19:06 -0700, Thomas Pedersen wrote:

> +/**
> + * __cfg80211_notify_new_candidate - see cfg80211_notify_new_candidate
> + *
> + * @dev: network device
> + * @macaddr: the MAC address of the new candidate
> + * @ie: information elements advertised by the peer candidate
> + * @ie_len: lenght of the information elements buffer
> + *
> + * Like cfg80211_notify_new_candidate(), but doesn't take the wdev lock.
> + */
> +void __cfg80211_notify_new_peer_candidate(struct net_device *dev,
> +		const u8 *macaddr, const u8 *ie, u8 ie_len);
> +
> +/**
>   * DOC: RFkill integration
>   *
>   * RFkill integration in cfg80211 is almost invisible to drivers,
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 26a0a08..994058f 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -243,6 +243,11 @@ struct cfg80211_event {
>  		struct {
>  			u8 bssid[ETH_ALEN];
>  		} ij;
> +		struct {
> +			u8 macaddr[ETH_ALEN];
> +			const u8 *ie;
> +			size_t ie_len;
> +		} nc;
>  	};
>  };

These bits are no longer necessary I believe.

johannes

