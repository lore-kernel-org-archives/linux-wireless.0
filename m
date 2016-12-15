Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41960 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935111AbcLOJIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:08:49 -0500
Message-ID: <1481792926.31776.1.camel@sipsolutions.net> (sfid-20161215_100908_037429_65531052)
Subject: Re: [RFC 0/3] Add new data path for ethernet frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:08:46 +0100
In-Reply-To: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-15 at 11:30 +0530, Vasanthakumar Thiagarajan wrote:
> This patch set adds a new data path to offload 802.11 header
> encap/decap to driver or hardware. Drivers having support
> for ieee80211 header encap/decap and other offload functionalities
> which can't be done before encap or after decap can make use of
> this new data path. Currently it is implemented for STA and AP
> interface type, this can be extend other interface types like
> adhoc.  

Thanks for posting this!

> With ath10k driver changes using this new Tx/Rx path, 10 - 15%
> CPU usage and upto ~20Mbps TCP performance improvements are
> observed with this ethernet data path. 

I'm sure that's because your CPU is severely limited :-)

> This patch set is
> prepared on a older mac80211 code base on top of
> commit 7d27a0ba7adc ("cfg80211: Add mesh peer AID setting API").
> Sorry, I could not get a chance to rework it on top of latest
> mac80211 code base.

Ok. I guess that doesn't matter much for review now.

> 	- Consider ieee8011 header and cipher header size also while
> updating tx/rx stats for
> 	  ethernet frame format.

I wonder if we really shouldn't be going the other way around instead,
to be closer to what Ethernet and likely other drivers do.

johannes
