Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39683 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbcELIXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 04:23:40 -0400
Message-ID: <1463041415.13313.6.camel@sipsolutions.net> (sfid-20160512_102344_060290_65B98E09)
Subject: Re: [PATCH] mac80211: Get ethtool-stats frequency more often.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Thu, 12 May 2016 10:23:35 +0200
In-Reply-To: <1462835537-11268-1-git-send-email-greearb@candelatech.com> (sfid-20160510_012230_890700_A6E8AB88)
References: <1462835537-11268-1-git-send-email-greearb@candelatech.com>
	 (sfid-20160510_012230_890700_A6E8AB88)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

I'm confused about the subject - "more often"?

> Some NICs (ath9k_htc) don't use chanctx_conf, it
> seems, so look at local->hw.conf.channel->center_freq
> in that case.

It shouldn't matter whether or not the *driver* (not NIC anyway) uses
that structure - mac80211 uses it throughout internally. As such, this
doesn't really make sense.

I also think that your patch is wrong because it causes a driver that
doesn't report information for the current channel to still have a non-
zero frequency, so userspace won't be able to tell if there's any data
or not.

johannes

