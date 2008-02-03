Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.230]:61897 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYBCPgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 10:36:12 -0500
Received: by hu-out-0506.google.com with SMTP id 19so1668196hue.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 07:36:10 -0800 (PST)
Message-ID: <247d6d340802030736t4a51c4bcg92130277f84e1b58@mail.gmail.com> (sfid-20080203_153616_750999_EF27100B)
Date: Sun, 3 Feb 2008 17:36:10 +0200
From: "Guy Cohen" <guy@cguy.net>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Patrick McHardy" <kaber@trash.net>
In-Reply-To: <200802020031.24532.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1201882512.4188.66.camel@johannes.berg>
	 <1201902217.4188.82.camel@johannes.berg>
	 <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com>
	 <200802020031.24532.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/2/08, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Saturday 02 February 2008, Tomas Winkler wrote:
> > 4965 has 4 queues which are used for regular WMM.  Only 11 queues
> > might be used for aggregation, but in AP mode we might map one of the
> > queues to after beacon multicast traffic.
>
> Just out of interest, and I don't know about the iwl4965 driver specifics,
> but how will you make sure those frames are send after the beacon?
> Does the beacon trigger an interrupt after each interval which allows you to queue
> the frames or is some other approach used?

For iwl4965, mcast frames are queued into a separate HW TX FIFO (no
need to buffer at the host). Beacon periodic transmission and
controling the TX of mcast frames from the mcast FIFO are all timely
done in real-time by the device.

Guy.
