Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:42410 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0DTRKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 13:10:48 -0400
Subject: Re: mac80211 and asymmetric 802.11n TX/RX
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <1271751747.8954.3.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Apr 2010 10:10:42 -0700
Cc: linux-wireless@vger.kernel.org
Message-Id: <6D966E94-4FD1-4675-B39B-296B4D82D2AB@cs.washington.edu>
References: <48BAD814-F653-4CE3-85E0-A9D82EC31D53@cs.washington.edu> <1271751747.8954.3.camel@jlt3.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Apr 20, 2010, at 1:22 AM, Johannes Berg wrote:
>> Does anyone know if the 11n standard says that the set of TX rates has
>> to be a subset of the set of RX rates? This seems to be enforced now:
>> when I set up one node to be 2x1, i.e. transmit 2 streams but only
>> able to receive 1, then the mac80211 code only lets it transmit 1
>> streams (even with a 2-stream-capable receiver at the other end).
> 
> I'm not sure. Reading 7.3.2.56.4 seems to imply that, but I'm not sure
> about the "Rx Highest Supported Data Rate" field. Seems like maybe you
> could set the "RX MCS bitmask" to more than is supported, limit it by
> the highest supported data rate, and then use the bitmask for TX?

First, did you mean 7.3.2.57.4? (I'm using IEEE P802.11n/D7.0, but I assume the section numbers haven't changed). For me that section represents the "Supported MCS Set field".

(An aside: I don't actually *have* 7.3.2.56. I'm using IEEE 802.11-2007 [has up to 7.3.2.35] and IEEE P802.11n/D7.0 [has 7.3.2.57 and beyond] --- In which document are the missing sections?)

Can you point me at which text in the section you think implies this requirement?

In any case, maybe this discussion is silly: I don't know of any devices with this strange configuration. Typically clients assume downlink-heavy and might support a 1x2 connection but 2x1, i.e. designed for uplink, seems unlikely.

>> A second question: my understanding is that if I am a 2x2 node and I
>> associate to a 3x3 AP, the same code will mask out the fact that the
>> AP can receive 3 streams since I can't transmit 3 streams. Is there a
>> way to access this info from the driver if I want it?
> 
> Unfortunately not, at this point. We could keep track of it, what would
> you need it for?

Okay, that's what I figured; I can hack around it locally. I'm working on an alternative rate selection algorithm that at one point tries to take into account how much receive diversity the other endpoint has. The intuition is that how well (e.g.) 2-stream rates work is going to depend not just on the channel, but also on how many excess antennas the receiver has. I would benefit from knowing whether they have 2 or 3 antennas even if I can only send them at most 2 streams.

Thanks,
Dan