Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16315 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZK0BGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 20:06:49 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259228968.32372.40.camel@johannes.local>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259228968.32372.40.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 09:06:54 +0800
Message-ID: <1259284014.13126.111.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-26 at 17:49 +0800, Johannes Berg wrote:
> > +     skb->dev = dev;
> > +     skb_queue_head_init(&frame_list);
> 
> ^ use __ versions please, no need for locking since it's on stack

You are right. Good catch!

> > +     dev->stats.rx_packets++;
> > +     dev->stats.rx_bytes += skb->len;
> 
> Shouldn't rx_packets be per sub-frame? 

Not very sure. Maybe it's one frame from the device's perspective? The
original code does this so I didn't change the behavior. Should I?

Thanks,
-yi

