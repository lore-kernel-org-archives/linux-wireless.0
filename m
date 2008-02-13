Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43276 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYBMMPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:15:08 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
Date: Wed, 13 Feb 2008 13:14:34 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200802122205.42799.mb@bu3sch.de> <1202904473.8931.31.camel@johannes.berg>
In-Reply-To: <1202904473.8931.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802131314.34930.mb@bu3sch.de> (sfid-20080213_121556_938649_F4401455)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 February 2008 13:07:53 Johannes Berg wrote:
> 
> > +	if (queue >= ARRAY_SIZE(wl->qos_params)) {
> > +		/* Queue not available or don't support setting
> > +		 * params on this queue. Return success to not
> > +		 * confuse mac80211. */
> > +		return 0;
> > +	}
> 
> Is that really necessary? If so, I'll probably remove it when doing the
> QoS rework, it shouldn't be, imho you should return an error if mac80211
> tries to configure a queue >= hw.queues.

Yep, mac80211 walks the whole queue array without looking at hw->queues.
I think this needs fixing in mac80211.

-- 
Greetings Michael.
