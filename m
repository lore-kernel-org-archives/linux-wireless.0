Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60340 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaJXJwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 05:52:15 -0400
Message-ID: <1414144324.1934.0.camel@jlt4.sipsolutions.net> (sfid-20141024_115218_970293_791D8501)
Subject: Re: [PATCH] mac80211: don't flush when probing the AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Oct 2014 11:52:04 +0200
In-Reply-To: <1413809838-9170-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1413809838-9170-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:57 +0300, Emmanuel Grumbach wrote:
> All the callers of ieee80211_mgd_probe_ap_send return right
> after they call the flush() callback. This means that calling
> flush() is uneeded since its meaning is to wait until the
> queues of the device are empty.
> 
> Devices that know how to report status on Tx will do so using
> the regular path (ieee80211_tx_status) and this status will
> trigger the continuation of the flow of the probe
> (ieee80211_sta_tx_notify).

Applied. For now, on mac80211-next, maybe we want to backport it later.

johannes

