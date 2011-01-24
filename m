Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:50736 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1AXFxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 00:53:20 -0500
Subject: Re: [PATCHv2] wl12xx: Increase scan channel dwell time for passive
 scans
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295616949.1925.118.camel@pimenta>
References: <1295332325-26477-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295616949.1925.118.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 07:53:12 +0200
Message-ID: <1295848392.18570.303.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 15:35 +0200, ext Luciano Coelho wrote:
> Hi Juuso,
> 
> Just a quick comment/question:
> 
> 
> On Tue, 2011-01-18 at 07:32 +0100, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The passive scan channel dwell time currently used is 30ms-60ms. A typical
> > beacon interval for AP's is 100ms. This leads to a ~30% worst-case probability
> > of finding an AP via passive scanning.
> 
> The beacon intervals are defined in TUs.
> 
> 
> > For 5GHz bands for DFS frequencies passive scanning is the only scanning
> > option. Hence for these, the probability of finding an AP is very low.
> > 
> > To fix this, increase the passive channel scan dwell times (also the early
> > leave value, as 5GHz channels are still typically very silent.) Use a value
> > of 100ms, because that covers most typical AP configurations.
> 
> In the firmware API, the dwell times are expressed in milli-TUs.  So I
> guess here you mean "use a value of 100 TUs", isn't it?

> > Based on testing the probability of finding an AP (102.4ms beacon interval) on
> > a single scan round are as follows (based on 100 iterations):
> 
> Here you use milliseconds for the AP beacon interval.  102.4ms is 100
> TUs, so that's correct.
> 
> It's just a bit confusing because of the slight difference between TUs
> and msecs.  Gery was wondering why you were using 100ms if the most
> common beacon interval is 102.4ms (100 TUs).  Of course, you're actually
> using 100 TUs, so it's fine.
> 
> I just think it's easier to follow if you forget msecs and use only TUs
> in your explanation.
> 

You're right. I'll convert the ms to mTU's in the description in v2.

This is a bit unclear to me too, though, because I don't know exactly
what the unit is we give the firmware. It's either TU/1024 or TU/1000.
Some reference I saw way back claimed it was plain TU's, which obviously
is not a possibility.

-Juuso

