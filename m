Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58665 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaJ1Q7y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 12:59:54 -0400
Message-ID: <1414515579.1834.4.camel@jlt4.sipsolutions.net> (sfid-20141028_175957_578961_C23DD741)
Subject: Re: [PATCH] ath10k: add tracing for tx ieee80211 header
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 28 Oct 2014 17:59:39 +0100
In-Reply-To: <1414514885-3694-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141028_174622_538480_F18A0459)
References: <1414514885-3694-1-git-send-email-rmanohar@qti.qualcomm.com>
	 (sfid-20141028_174622_538480_F18A0459)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-28 at 22:18 +0530, Rajkumar Manoharan wrote:
> For packet log, the transmitted frame 802.11 header alone is sufficient.
> Recording entire packet is also consuming lot of disk space. To
> optimize, add tracepoints for sending tx-ed 802.11 headers alone.

FWIW, in iwlwifi I made the data portion (only!) a separate tracing
subsystem, so that you can do

trace-cmd record -e iwlwifi

to get the hdrs, and

trace-cmd record -e iwlwifi -e iwlwifi_data

to get the hdrs, and the data, and then I put the two together in
userspace. That way, "-e iwlwifi" gets most useful stuff, and adding -e
iwlwifi_data when needed still has no duplication.

With what you're suggesting, it will be difficult to control tracing to
do exactly what's needed.

Anyway, I don't really care, but this just caught my eye.

johannes

