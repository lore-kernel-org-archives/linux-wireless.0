Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58883 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbBWIfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 03:35:42 -0500
Message-ID: <1424680539.2782.1.camel@sipsolutions.net> (sfid-20150223_093601_020140_8C3E0030)
Subject: Re: [RFC] zero-copy AMSDU processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Feb 2015 09:35:39 +0100
In-Reply-To: <1708052.J876aMsZU2@lx-wigig-72> (sfid-20150219_115139_326083_61D4FCF7)
References: <1708052.J876aMsZU2@lx-wigig-72>
	 (sfid-20150219_115139_326083_61D4FCF7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-19 at 12:51 +0200, Vladimir Kondratiev wrote:
> I am looking for ideas how can one process AMSDU in the software, without copying data.
> Current implementation like ieee80211_amsdu_to_8023s() do copy packet data.
> 
> Assume I got in the driver, MPDU that is AMSDU containing several MSDU's.
> It is in the single memory buffer that was allocated for DMA.
> Can I construct skb's per MSDU with minimal data copy, having most of the
> original data in place? Any ideas for this?

As you noticed, this implementation is very inefficient.

If the SKB has pages (rather than being linear, as
ieee80211_amsdu_to_8023s() assumes) then what Emmanuel said would
probably be the best approach, although it could be possible that would
mess up truesize accounting and lead to lower performance. Certainly
you'd want to do it only for suitably large packets (at least bigger
than 128 bytes or so)

johannes

