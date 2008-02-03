Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:46756 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYBCPzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 10:55:22 -0500
Received: by an-out-0708.google.com with SMTP id d31so439385and.103
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 07:55:21 -0800 (PST)
To: "Guy Cohen" <guy@cguy.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Sun, 3 Feb 2008 16:54:54 +0100
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Patrick McHardy" <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg> <200802020031.24532.IvDoorn@gmail.com> <247d6d340802030736t4a51c4bcg92130277f84e1b58@mail.gmail.com>
In-Reply-To: <247d6d340802030736t4a51c4bcg92130277f84e1b58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802031654.54311.IvDoorn@gmail.com> (sfid-20080203_155528_181105_1CEC62B5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 February 2008, Guy Cohen wrote:
> On 2/2/08, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > On Saturday 02 February 2008, Tomas Winkler wrote:
> > > 4965 has 4 queues which are used for regular WMM.  Only 11 queues
> > > might be used for aggregation, but in AP mode we might map one of the
> > > queues to after beacon multicast traffic.
> >
> > Just out of interest, and I don't know about the iwl4965 driver specifics,
> > but how will you make sure those frames are send after the beacon?
> > Does the beacon trigger an interrupt after each interval which allows you to queue
> > the frames or is some other approach used?
> 
> For iwl4965, mcast frames are queued into a separate HW TX FIFO (no
> need to buffer at the host). Beacon periodic transmission and
> controling the TX of mcast frames from the mcast FIFO are all timely
> done in real-time by the device.

Thanks for the explanation.

Ivo
