Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34878 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaKRVkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 16:40:39 -0500
Message-ID: <1416346831.1939.7.camel@sipsolutions.net> (sfid-20141118_224043_056164_FEE7E9E0)
Subject: Re: [PATCH 3.18] mac80211: minstrel_ht: fix a crash in rate sorting
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi,
	thomas@net.t-labs.tu-berlin.de
Date: Tue, 18 Nov 2014 22:40:31 +0100
In-Reply-To: <1416346531-61703-1-git-send-email-nbd@openwrt.org>
References: <1416346531-61703-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-18 at 22:35 +0100, Felix Fietkau wrote:
> The commit 5935839ad73583781b8bbe8d91412f6826e218a4
> "mac80211: improve minstrel_ht rate sorting by throughput & probability"
> 
> introduced a crash on rate sorting that occurs when the rate added to
> the sorting array is faster than all the previous rates. Due to an
> off-by-one error, it reads the rate index from tp_list[-1], which
> contains uninitialized stack garbage, and then uses the resulting index
> for accessing the group rate stats, leading to a crash if the garbage
> value is big enough.

Applied, thanks.

johannes

