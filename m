Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2KEMAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 07:00:39 -0500
Message-ID: <1352116868.9466.2.camel@jlt4.sipsolutions.net> (sfid-20121105_130053_135957_686DED92)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, johannes.berg@intel.com,
	florian@reitmeir.org, linux-wireless@vger.kernel.org
Date: Mon, 05 Nov 2012 13:01:08 +0100
In-Reply-To: <50979D38.6010002@ehuk.net> (sfid-20121105_121423_464154_72561532)
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	 <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	 (sfid-20121105_121423_464154_72561532)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 11:04 +0000, Eddie Chapman wrote:

> > And, can you also test 3.7-rc4, to ensure that the problem isn't there
> > as well?


> I've narrowed it down to this patch which introduces the problem:
> 
> Johannes Berg:
> mac80211: connect with HT20 if HT40 is not permitted
> commit: 3a40414f826a8f1096d9b94c4a53ef91b25ba28d
> 
> The other 3 patches above give me no problems at all, so I am now 
> running my 3.6.5 with those 3 back in, and just the HT20/HT40 patch 
> removed, and throughput is perfect. As soon as I introduce the patch 
> HT20/HT40 throughput drops right down to a fifth of what it was.

This should also be the case on 3.7-rc4, since the patch came from
there, and I don't see any reason to believe rt2800 would behave
differently here, for some reason.

Can you show me the contents of
the /sys/kernel/debug/ieee80211/phy0/ht40allow_map debugfs file and "iw
reg get" command?

johannes

