Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3AaPpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:45:47 -0500
Message-ID: <1359647168.8415.83.camel@jlt4.sipsolutions.net> (sfid-20130131_164550_960051_3435C365)
Subject: Re: [PATCH] mac80211: improve latency and throughput while software
 scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Sam Leffler <sleffler@chromium.org>,
	Paul Stewart <pstew@chromium.org>
Date: Thu, 31 Jan 2013 16:46:08 +0100
In-Reply-To: <20130123113244.GA2941@redhat.com> (sfid-20130123_123259_415260_578716DF)
References: <20130123113244.GA2941@redhat.com>
	 (sfid-20130123_123259_415260_578716DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 12:32 +0100, Stanislaw Gruszka wrote:
> Patch vastly improve latency while scanning. Slight throughput
> improvements were observed as well. Is intended for improve performance
> of voice and video applications, when scan is periodically requested by
> user space (i.e. default NetworkManager behaviour).
> 
> Patch remove latency requirement based on PM_QOS_NETWORK_LATENCY,
> this value is 2000 seconds by default (i.e. approximately 0.5 hour !?!).
> 
> Also remove listen interval requirement, which based on beaconing and
> depending on BSS parameters. It can make we stay off-channel for a
> second or more.
> 
> Instead try to offer the best latency that we could, i.e. be off-channel
> no longer than PASSIVE channel scan time: 125 ms. That mean we will
> scan two ACTIVE channels and go back to on-channel, and one PASSIVE
> channel, and go back to on-channel.
> 
> Patch also decrease PASSIVE channel scan time to about 110 ms.
> 
> As drawback patch increase overall scan time. On my tests, when scanning
> both 2GHz and 5GHz bands, scanning time increase from 5 seconds up to 10
> seconds. Since that increase happen only when we are associated, I think
> it can be acceptable. If eventually better scan time is needed for
> situations when we lose signal and quickly need to decide to which AP
> roam, additional scan flag or parameter can be introduced.
> 
> I tested patch by doing:
> 
> while true; do iw dev wlan0 scan; sleep 3; done > /dev/null
> 
> and
> 
> ping -i0.2 -c 1000 HOST
> 
> on remote and local machine, results are as below:
> 
> * Ping from local periodically scanning machine to AP:
> Unpatched: rtt min/avg/max/mdev = 0.928/24.946/182.135/36.873 ms
> Patched:   rtt min/avg/max/mdev = 0.928/19.678/150.845/33.130 ms
> 
> * Ping from remote machine to periodically scanning machine:
> Unpatched: rtt min/avg/max/mdev = 1.637/120.683/709.139/164.337 ms
> Patched:   rtt min/avg/max/mdev = 1.807/26.893/201.435/40.284 ms
> 
> Throughput measured by scp show following results.
> 
> * Upload to periodically scanning machine:
> Unpatched: 3.9MB/s   03:15    
> Patched:   4.3MB/s   02:58
> 
> * Download from periodically scanning machine:
> Unpatched: 5.5MB/s   02:17
> Patched:   6.2MB/s   02:02

Applied.

johannes

