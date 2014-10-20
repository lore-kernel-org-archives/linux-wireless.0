Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36661 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJTKlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:41:36 -0400
Message-ID: <1413801688.10246.18.camel@jlt4.sipsolutions.net> (sfid-20141020_124138_964913_86FB0FED)
Subject: Re: [RFC] mac80211: don't flush when probing the AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Oct 2014 12:41:28 +0200
In-Reply-To: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413491157-5352-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-16 at 23:25 +0300, Emmanuel Grumbach wrote:
> All the callers of ieee80211_mgd_probe_ap_send return right
> after they call the flush() callback. This means that calling
> flush() is uneeded since its meaning is to wait until the
> queues of the device are empty. It is pointless to wait if
> there is nothing that must ensure that the frame has left
> the Tx queue.
> ieee80211_mgd_probe_ap_send is called at the very end of
> a worker - so flush() is not needed.

There may have been some concern that the timer/work could run again
while the packets are still on the (possibly long) queue, but I guess
this is reasonable? We might want to avoid that by tracking whether
we've sent out a frame and (not) gotten a response?

johannes

