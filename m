Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0HUKEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 06:04:30 -0400
Subject: Re: [PATCH 1/1] mac80211: fix warning for un-used parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1282340976-10665-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282340976-10665-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 12:04:25 +0200
Message-ID: <1282385065.3759.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-20 at 14:49 -0700, wey-yi.w.guy@intel.com wrote:

> @@ -1701,7 +1701,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	u16 ethertype, hdrlen,  meshhdrlen = 0;
>  	__le16 fc;
>  	struct ieee80211_hdr hdr;
> +#ifdef CONFIG_MAC80211_MESH
>  	struct ieee80211s_hdr mesh_hdr;
> +#endif

Good catch. I think just adding __maybe_unused would be better though?

johannes

