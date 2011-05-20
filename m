Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab1ETPKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 11:10:42 -0400
Subject: Re: [PATCH 1/2]: mac80211: set tx rate and retries when injecting
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTin6ettB1nhnrAjDncX1MrahfS4Z6g@mail.gmail.com> (sfid-20110520_011405_835059_85A96447)
References: <BANLkTin6ettB1nhnrAjDncX1MrahfS4Z6g@mail.gmail.com>
	 (sfid-20110520_011405_835059_85A96447)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:11:46 -0700
Message-ID: <1305904306.4640.0.camel@jlt3.sipsolutions.net> (sfid-20110520_171045_263111_D0C4EE51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +++ b/net/mac80211/ieee80211_i.h	2011-05-20 00:24:14.010640270 +0200
> @@ -1217,6 +1217,10 @@
>  	u8 padding_for_rate;
>  	__le16 tx_flags;
>  	u8 data_retries;
> +	/*HT info*/
> +	u8 ht_known;
> +	u8 ht_flag;
> +	u8 ht_mcs;
>  } __packed;

> --- a/include/net/mac80211.h	2011-05-20 00:22:56.210640264 +0200
> +++ b/include/net/mac80211.h	2011-05-20 00:24:14.020640270 +0200
> @@ -2278,7 +2278,7 @@
>   * The TX headroom reserved by mac80211 for its own tx_status functions.
>   * This is enough for the radiotap header.
>   */
> -#define IEEE80211_TX_STATUS_HEADROOM	13
> +#define IEEE80211_TX_STATUS_HEADROOM	16

This both belongs to the other patch.

johannes

