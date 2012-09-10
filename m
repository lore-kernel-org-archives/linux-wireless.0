Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:50376
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab2IJJ7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 05:59:46 -0400
Message-ID: <504DBA13.3060505@posedge.com> (sfid-20120910_115949_748764_FEBA03D1)
Date: Mon, 10 Sep 2012 15:29:47 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC v2] cfg80211: VHT regulatory
References: <5046FB3D.6090803@posedge.com>   <1346852356.4364.9.camel@jlt4.sipsolutions.net>   <50481C2E.5040303@posedge.com>  <1346925298.5469.4.camel@jlt4.sipsolutions.net>  <50489165.1080902@posedge.com> <1347019809.4256.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347019809.4256.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/7/2012 5:40 PM, Johannes Berg wrote:
> We don't have to do any calculation in kernel though as far as I can
> tell? Maybe we do need the channel, but I think in terms of
> *specifying*, in particular in the nl80211 and cfg80211 APIs, we should
> stick to the standard if we're going to change it now.
>

If we don't have to do any calculation, what for the formulas in spec? 
converting chan number to frequency value. Just with channel number 
entire cfg,mac and drivers are fine?

>
> I have no idea. I don't know the regulatory code very well, sorry.
>

Sorry I take it back. we can pass center freq to get reg rule. RFC v3 is 
on way ...

>
> It seems to me that if we're going to specify things as an overall
> center frequency + bandwidth then we don't really care about
> primary/secondary channels? We'd rather just get the reg rule(s) from
> the center freq(s)/bandwidth, and then check all channels that happen to
> fall into this space, or something like that?
>
> Even if we do that, there's still another issue though. Some drivers,
> like ours, don't support HT40 everywhere. Right now I believe we pretty
> much support HT40 everywhere that is allowed, but that might not be the
> case for all drivers.
>
> So previously, the driver was able to set the IEEE80211_CHAN_NO_HT40PLUS
> etc. flags on a channel before registering. If we remove these flags
> we'll have to find a way to allow the driver to influence the decision
> about what is allowed in some way, I guess? Or maybe the driver would
> have to register a regulatory rule that encapsulates everything in the
> device's EEPROM?

Let me know if my RFC v3 is ok for this.
>
> johannes
>

-- 
Thanks,
Mahesh
