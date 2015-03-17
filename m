Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53189 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbbCQKDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:03:55 -0400
Message-ID: <1426586632.1985.5.camel@sipsolutions.net> (sfid-20150317_110404_469271_13AF6EE2)
Subject: Re: [PATCH] mac80211: minstrel_ht: fix rounding issue in MCS
 duration calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Date: Tue, 17 Mar 2015 11:03:52 +0100
In-Reply-To: <1426240484-37307-1-git-send-email-nbd@openwrt.org>
References: <1426240484-37307-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-13 at 10:54 +0100, Felix Fietkau wrote:
> On very high MCS bitrates, the calculated duration of rates that are
> next to each other can be very imprecise, due to the small packet size
> used as reference (1200 bytes).
> This is most visible in VHT80 nss=2 MCS8/9, for which minstrel shows the
> same throughput when the probability is also the same. This leads to a
> bad rate selection for such rates.
> 
> Fix this issue by introducing an average A-MPDU size factor into the
> calculation.

Applied.

johannes

