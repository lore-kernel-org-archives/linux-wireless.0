Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36258 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbbAGOMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:12:12 -0500
Message-ID: <1420639929.3407.18.camel@sipsolutions.net> (sfid-20150107_151223_387613_C33E9AFD)
Subject: Re: [PATCHv4] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Date: Wed, 07 Jan 2015 15:12:09 +0100
In-Reply-To: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150106_184113_066053_088DBBD3)
References: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20150106_184113_066053_088DBBD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 18:41 +0100, Lorenzo Bianconi wrote:

> + * @txpower_type: TX power adjustment used to control per packet Transmit
> + *	Power Control (TPC) in lower driver for the current vif. In particular
> + *	TPC is enabled if value passed in %txpower_type is
> + *	NL80211_TX_POWER_AUTOMATIC (no limit from userspace) or
> + *	NL80211_TX_POWER_LIMITED (allow using less than specified from
> + *	userspace), whereas TPC is disabled if %txpower_type is set to
> + *	NL80211_TX_POWER_FIXED (use value configured from userspace)

I was going to apply this, but now I have second thoughts.

Does it really make sense to ask the driver to do "automatic"? After
all, there are other limits in mac80211 (like 11h from the AP and
regulatory) that need to be considered. So perhaps if userspace says
"automatic", the driver should still see only "limited"?

johannes

