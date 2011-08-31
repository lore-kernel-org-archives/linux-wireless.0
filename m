Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:52135 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab1HaIDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 04:03:34 -0400
Received: by mail-ew0-f41.google.com with SMTP id 9so253963ewy.0
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 01:03:32 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314777264.4161.21.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
	 <1314776396.4161.19.camel@jlt3.sipsolutions.net>
	 <1314776962.2296.540.camel@cumari>
	 <1314777198.4161.20.camel@jlt3.sipsolutions.net>
	 (sfid-20110831_095327_725277_2680941D)  <1314777264.4161.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 11:03:29 +0300
Message-ID: <1314777809.2296.548.camel@cumari> (sfid-20110831_100346_396983_3693EBA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:54 +0200, Johannes Berg wrote: 
> On Wed, 2011-08-31 at 09:53 +0200, Johannes Berg wrote:
> 
> > > MATCH={BSSID=00:01:02:03:04:05} and
> > > NOT_MATCH={MIN_RSSI=-70}
> 
> Actually does that really make sense?
> 
> I suspect you'd want something like
> 
> MATCH SSID="foo" && RSSI >= -70
> 
> where the && part isn't really expressed now?

Ahmmm... yes, the actual parameters don't make much sense. :D

But about &&, I guess it's should be like this:

MATCH={1=... OR 2=... OR 3=...} AND NOT_MATCH={1=... NOR 2=...}

So the netfiltery way of doing it would be much more complicated,
because we would have to specify ANDs and ORs explicitly in the list
somehow.

-- 
Cheers,
Luca.

