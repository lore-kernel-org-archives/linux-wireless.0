Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2FFGi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 02:38:28 -0400
Message-ID: <1338964705.4513.3.camel@jlt3.sipsolutions.net> (sfid-20120606_083831_157225_2D71E88F)
Subject: Re: [PATCH v2] mac80211: stop Rx during HW reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 08:38:25 +0200
In-Reply-To: <1338964357-21685-1-git-send-email-arik@wizery.com> (sfid-20120606_083243_872029_F444401F)
References: <1338964357-21685-1-git-send-email-arik@wizery.com>
	 (sfid-20120606_083243_872029_F444401F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 09:32 +0300, Arik Nemtsov wrote:

> +++ b/net/mac80211/rx.c
> @@ -3023,6 +3023,9 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	if (WARN_ON(!sband))
>  		goto drop;
>  
> +	/* make sure we get the latest values for the next variable checks */
> +	smp_rmb();
> +

I still don't think this makes a lot of sense. It's guaranteed racy, so
what does this buy us?

johannes

