Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34852 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYJMXgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:36:43 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223939271.10113.10.camel@johannes.berg>
References: <48EE20FB.4060700@lwfinger.net>
	 <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
	 <200810140055.34065.chunkeey@web.de>  <1223938526.27118.6.camel@dv>
	 <1223939151.27769.3.camel@dv>  <1223939271.10113.10.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 19:36:41 -0400
Message-Id: <1223941001.28019.3.camel@dv> (sfid-20081014_013648_076213_DD837945)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 01:07 +0200, Johannes Berg wrote:
> On Mon, 2008-10-13 at 19:05 -0400, Pavel Roskin wrote:
> 
> > And if I set rx_status.rate_idx to 0, I still get that badness for the
> > same reason (status->rate_idx = 12, sband->n_bitrates = 8).  
> 
> ??
> That's not right, if you set rx_status.rate_idx to 0 status->rate_idx
> should be 0 :)

Sorry, I didn't code it right.  You are correct.

> > Also, there
> > is another badness reported sometimes:
> 
> That's new. On a whim I decided that I wanted to know why config() had a
> return value ;) Will see why p54 makes it fail, maybe there's a mac80211
> bug.

p54_config() calls p54_set_freq(), which can fail with -EINVAL.  I'm
looking why it can happen.

-- 
Regards,
Pavel Roskin
