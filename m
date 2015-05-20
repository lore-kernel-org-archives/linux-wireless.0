Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37222 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbbETNIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:08:50 -0400
Message-ID: <1432127328.19214.10.camel@sipsolutions.net> (sfid-20150520_150854_282156_78055015)
Subject: Re: [PATCH] mac80211: check fast-xmit on station change
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:08:48 +0200
In-Reply-To: <1432037616-26520-1-git-send-email-michal.kazior@tieto.com> (sfid-20150519_141349_970329_7AE95667)
References: <1432037616-26520-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150519_141349_970329_7AE95667)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 14:13 +0200, Michal Kazior wrote:
> Drivers with fast-xmit (e.g. ath10k) running in
> AP_VLAN setups would fail to communicate with
> connected 4addr stations.
> 
> The reason was when new station associates it
> first goes into master AP interface. It is not
> until later that a dedicated AP_VLAN is created
> for it and the station itself is moved there.
> After that Tx directed at the station should use
> 4addr header. However fast-xmit wasn't
> recalculated and 3addr header remained to be used.
> This in turn caused the connected 4addr stations
> to drop packets coming from the AP until some
> other event would cause fast-xmit to recalculate
> for that station (which could never come).

Applied.

johannes

