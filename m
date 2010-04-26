Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62071 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab0DZVuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 17:50:09 -0400
Subject: Re: [PATCH] mac80211: fix handling of 4-address-mode in
 ieee80211_change_iface
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <4BD5D34F.8080205@openwrt.org>
References: <4BD5D34F.8080205@openwrt.org>
Content-Type: text/plain
Date: Mon, 26 Apr 2010 17:50:07 -0400
Message-Id: <1272318607.22987.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 19:54 +0200, Felix Fietkau wrote:
> A misplaced interface type check bails out too early if the interface
> is not in monitor mode. This patch moves it to the right place, so that
> it only covers changes to the monitor flags.
...
> +	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
> +		return 0;
> +
>  	sdata->u.mntr_flags = *flags;
>  	return 0;
>  }

Perhaps you could write it in a more readable way:

       if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
               sdata->u.mntr_flags = *flags;

       return 0;

Just an idea, not an objection.

-- 
Regards,
Pavel Roskin
