Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46862 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbbFQJBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:01:33 -0400
Message-ID: <1434531691.1884.19.camel@sipsolutions.net> (sfid-20150617_110143_744138_3B56DCA4)
Subject: Re: [PATCH] mac80211: enable assoc check for mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 17 Jun 2015 11:01:31 +0200
In-Reply-To: <1434204991-9579-1-git-send-email-me@bobcopeland.com> (sfid-20150613_161648_437877_9DE6CF3A)
References: <1434204991-9579-1-git-send-email-me@bobcopeland.com>
	 (sfid-20150613_161648_437877_9DE6CF3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-06-13 at 10:16 -0400, Bob Copeland wrote:
> We already set a station to be associated when peering completes, both
> in user space and in the kernel.  Thus we should always have an
> associated sta before sending data frames to that station.
> 
> Failure to check assoc state can cause crashes in the lower-level driver
> due to transmitting unicast data frames before driver sta structures
> (e.g. ampdu state in ath9k) are initialized.  This occurred when
> forwarding in the presence of fixed mesh paths: frames were transmitted
> to stations with whom we hadn't yet completed peering.

Applied.

johannes

