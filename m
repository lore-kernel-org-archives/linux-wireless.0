Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYPo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:27 -0400
Message-ID: <1398440652.4152.25.camel@jlt4.sipsolutions.net> (sfid-20140425_174436_365375_9FF12F25)
Subject: Re: [PATCH 1/7] cfg80211: export expected throughput through
 get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Fri, 25 Apr 2014 17:44:12 +0200
In-Reply-To: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Users may need information about the expected throughput

I think this "expected throughput" should be a bit clarified.

Are you talking about "expected PHY rate" or rather "expected (payload)
throughput"?

> towards a given peer computed by the RC algorithm.
> Export such value in Mbps/100 through the get_station() API.

"units of 10Kbps" might be a better description :-)

> This unit has been chosen because it is the same of the
> throughput returned by MinstrelHT.

Since it's unlikely we'll ever reach the limit of a u32, maybe just
multiply by 10 to get the nicer Kbps?

> + * @expected_throughput: expected throughput in Mbps/100 reported by the RC
> + *	algorithm towards this station. The unit of this value has been chosen
> + *	because it is the same of the throughput returned by MinstrelHT

I think the rationale shouldn't be here now.

johannes

