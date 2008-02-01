Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:62880 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761928AbYBAXbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 18:31:47 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1107512fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 15:31:46 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Sat, 2 Feb 2008 00:31:24 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Patrick McHardy" <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg> <1201902217.4188.82.camel@johannes.berg> <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com>
In-Reply-To: <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802020031.24532.IvDoorn@gmail.com> (sfid-20080201_233153_155559_CD07EBE8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 February 2008, Tomas Winkler wrote:
> On Feb 1, 2008 11:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > Any thoughts on this patch? The only thing it should really actually
> > change is removing the IBSS beacon queue configuration, but as I've
> > explained previously that really has to be done by the driver because we
> > don't know whether the driver even uses queues for beaconing... Also we
> > never reset that info.
> >
> > Also, I'm wondering, iwl4965 has 16 queues, can it use 4 for regular WMM
> > and the other 12 for aggregation? And how does it configure the access
> > parameters for aggregation? I don't see conf_tx() calls anywhere for
> > that.
> >
> 
> 4965 has 4 queues which are used for regular WMM.  Only 11 queues
> might be used for aggregation, but in AP mode we might map one of the
> queues to after beacon multicast traffic.

Just out of interest, and I don't know about the iwl4965 driver specifics,
but how will you make sure those frames are send after the beacon?
Does the beacon trigger an interrupt after each interval which allows you to queue
the frames or is some other approach used?

I am asking because I am not sure how I should implement such a thing for
the rt2x00 drivers that don't have a device ATIM queue (which automatically
sends the frames after the beacon was send).

> One queue is reserved for communicating with FW.  The number my differ
> on further NICs.
> 
> All the traffic queues 4 WMM + 11 AGG are served according regular WMM
> policy, 4 AC - these are configured by conf_tx.  The aggregation
> queues are needed for handling ordering of frames correctly and not
> for on media prioritizing
> 
> Sorry but I have to review your patch later
> Thanks
> Tomas

