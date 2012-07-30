Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2G3NiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 09:38:24 -0400
Message-ID: <1343655501.4452.15.camel@jlt3.sipsolutions.net> (sfid-20120730_153827_375538_1BB77962)
Subject: Re: [PATCH 1/2] mac80211: Add support of transmit power control
 (TPC) per data packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Date: Mon, 30 Jul 2012 15:38:21 +0200
In-Reply-To: <5016702D.8000801@net.t-labs.tu-berlin.de>
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	  <1343404809-70329-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	  (sfid-20120727_180037_367100_88493A5C) <1343633674.4452.3.camel@jlt3.sipsolutions.net>
	 <5016702D.8000801@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-30 at 13:29 +0200, Thomas Huehn wrote:

> >> - *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
> >> + *    { 3, 2, 16 }, { 2, 2, 10 }, { 1, 4, 5 }, { -1, 0, 0 }
> >>   * then this means that the frame should be transmitted
> >> - * up to twice at rate 3, up to twice at rate 2, and up to four
> >> - * times at rate 1 if it doesn't get acknowledged. Say it gets
> >> - * acknowledged by the peer after the fifth attempt, the status
> >> + * up to twice at rate 3 with 16 dBm, up to twice at rate 2 with 10 dBm,
> > 
> > You might want to consider using 1/2 or 1/4 dBm granularity? A lot of
> > hardware can do that.
> > 
> 
> 
> The choice of 1 dBm as step width was based on our experiments with
> Atheros chips that do support up to 0,5dBm step width. We concluded that
> 1dBm is sufficient as it provides 20 steps from 1 till 100 mWatt as
> dynamic range of control. But there is no problem for my tpc algorithm
> to handle a granularity of 0.5 dBm as step size, or any other upcoming
> tpc controller. Should we gather some feedback about todays hardware
> specs in terms of tx_power abilities? Or should I just apply 0.5 dBm
> steps in v2 ?

I have no idea, it was really just a thought. I believe Broadcom HW can
handle 1/4 dBm, but then you'd have to know what the granularity really
is otherwise it all doesn't make much sense...

It really only gets interesting if there's a limit (regulatory or
otherwise) that isn't a full dBm, because then the algorithm couldn't
use the maximum permitted power, right? Say there's a 14.5 dBm limit,
then the algorithm could only go up to 14 dBm.

johannes

