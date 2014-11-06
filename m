Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41889 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKFPDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 10:03:42 -0500
Message-ID: <1415286217.17015.12.camel@sipsolutions.net> (sfid-20141106_160355_899808_B071F3D2)
Subject: Re: New WARNING from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 06 Nov 2014 16:03:37 +0100
In-Reply-To: <545B8CD1.8020208@lwfinger.net> (sfid-20141106_155933_146634_B5D1D491)
References: <545B8CD1.8020208@lwfinger.net>
	 (sfid-20141106_155933_146634_B5D1D491)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 08:59 -0600, Larry Finger wrote:

> The warning comes from the following fragment in net/mac80211/agg-tx.c:
> 
>          if (WARN_ON(!tid_tx)) {
>                  ht_dbg(sdata, "addBA was not requested!\n");
>                  goto unlock;
>          }
> 
> Is there something that should be fixed in rtl8192se?

That sounds like the driver is calling ieee80211_start_tx_ba_cb() [*]
when it was never requested to start aggregation?

[*] given the stack dump, it's actually calling
ieee80211_start_tx_ba_cb_irqsafe() which goes off to a workqueue and
then calls ieee80211_start_tx_ba_cb() from there

johannes

