Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56109
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXD2JP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 05:15:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 3/4] mac80211: document requirement for atomicity of callbacks
Date: Sun, 29 Apr 2007 11:15:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070429023215.40c2aea7@logostar.upir.cz> <20070429023345.43e09faf@logostar.upir.cz>
In-Reply-To: <20070429023345.43e09faf@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704291115.43657.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 April 2007 02:33:45 Jiri Benc wrote:
> @@ -631,7 +632,8 @@ struct ieee80211_ops {
>  	 * we need to combine the multicast lists and flags for multiple
>  	 * virtual interfaces), they cannot assign set_multicast_list.
>  	 * The parameters here replace dev->flags and dev->mc_count,
> -	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item. */
> +	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item.
> +	 * Must be atomic. */
>  	void (*set_multicast_list)(struct ieee80211_hw *hw,
>  				   unsigned short flags, int mc_count);

Why is that required to be atomic, actually?

>  	/* Set encryption key. IEEE 802.11 module calls this function to set
> @@ -647,7 +650,8 @@ struct ieee80211_ops {
>  	 * station hwaddr for individual keys. aid of the station is given
>  	 * to help low-level driver in selecting which key->hw_key_idx to use
>  	 * for this key. TX control data will use the hw_key_idx selected by
> -	 * the low-level driver. */
> +	 * the low-level driver.
> +	 * Must be atomic. */
>  	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
>  		       u8 *addr, struct ieee80211_key_conf *key, int aid);

I think USB drivers and bcm43xx violate that. We can't easily workaround it
without doing the operation async.


-- 
Greetings Michael.
