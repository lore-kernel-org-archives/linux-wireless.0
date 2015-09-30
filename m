Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51643 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbbI3ScV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 14:32:21 -0400
Message-ID: <1443637937.1859.19.camel@sipsolutions.net> (sfid-20150930_203253_594716_3CF517AD)
Subject: Re: Rate limiting AP bandwidth change messages in
 ieee80211_config_bw?
From: Johannes Berg <johannes@sipsolutions.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2015 20:32:17 +0200
In-Reply-To: <CA+5PVA4yaLG2NtJ_Bg5-BQzR-Wa5ABxPb-cLxF7bjSsf-P1_5Q@mail.gmail.com> (sfid-20150930_190254_762697_55F052FA)
References: <CA+5PVA4yaLG2NtJ_Bg5-BQzR-Wa5ABxPb-cLxF7bjSsf-P1_5Q@mail.gmail.com>
	 (sfid-20150930_190254_762697_55F052FA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-30 at 13:02 -0400, Josh Boyer wrote:
> Hi Johannes,
> 
> We've seen a handful of reports that seem to have verbose output from
> the ieee80211_config_bw function in net/mac80211/mlme.c.  It looks
> similar to this:
> 
> [   66.578652] wlp3s0: AP xx:xx:xx:xx:xx changed bandwidth, new config
> is 2437 MHz, width 2 (2447/0 MHz)
> [   68.522437] wlp3s0: AP xx:xx:xx:xx:xx changed bandwidth, new config
> is 2437 MHz, width 1 (2437/0 MHz)

> Essentially, this looks like the AP is changing the bandwidth (and
> only the width) every second or so.  Why it is doing this, I'm not
> sure.  However, this doesn't seem to actually be an error case yet the
> kernel logs are getting spammed with this message.
> 
> I'm wondering if we could either change this message to use sdata_dbg
> instead of sdata_info, or if we could possibly ratelimit it somehow.
> I'd be happy to come up with a patch for either, but I wanted to get
> your feedback on it before I started.  Do you have any objections or
> preference?
> 

I'm not sure ratelimiting it would even work - it's not *that* high
frequency? Not really sure though.

I think we can do either, it's not such a terribly important message as
far as I can tell.

johannes
