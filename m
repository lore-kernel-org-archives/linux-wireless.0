Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50650 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1AUNft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 08:35:49 -0500
Subject: Re: [PATCHv2] wl12xx: Increase scan channel dwell time for passive
 scans
From: Luciano Coelho <coelho@ti.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295332325-26477-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295332325-26477-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 15:35:49 +0200
Message-ID: <1295616949.1925.118.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

Just a quick comment/question:


On Tue, 2011-01-18 at 07:32 +0100, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The passive scan channel dwell time currently used is 30ms-60ms. A typical
> beacon interval for AP's is 100ms. This leads to a ~30% worst-case probability
> of finding an AP via passive scanning.

The beacon intervals are defined in TUs.


> For 5GHz bands for DFS frequencies passive scanning is the only scanning
> option. Hence for these, the probability of finding an AP is very low.
> 
> To fix this, increase the passive channel scan dwell times (also the early
> leave value, as 5GHz channels are still typically very silent.) Use a value
> of 100ms, because that covers most typical AP configurations.

In the firmware API, the dwell times are expressed in milli-TUs.  So I
guess here you mean "use a value of 100 TUs", isn't it?


> Based on testing the probability of finding an AP (102.4ms beacon interval) on
> a single scan round are as follows (based on 100 iterations):

Here you use milliseconds for the AP beacon interval.  102.4ms is 100
TUs, so that's correct.

It's just a bit confusing because of the slight difference between TUs
and msecs.  Gery was wondering why you were using 100ms if the most
common beacon interval is 102.4ms (100 TUs).  Of course, you're actually
using 100 TUs, so it's fine.

I just think it's easier to follow if you forget msecs and use only TUs
in your explanation.


-- 
Cheers,
Luca.

