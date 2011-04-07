Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1DGKd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 06:33:56 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before
 entering power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	 <1301658705.3832.21.camel@jlt3.sipsolutions.net>
	 <AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 12:33:55 +0200
Message-ID: <1302172435.3779.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 17:42 +0530, Vivek Natarajan wrote:

> Ideally the driver should enter power save only when there is no tx
> frame. When there are about 10 APs in the environment the tx rate of
> the driver drops and the application slows down since it has not yet
> received ACKs for the frames already queued in the hardware. Since
> this ACK may take more than 100ms, stopping the dev queues for
> entering PS at this stage breaks applications, WMM test case in my
> testing. If there are tx_frames already pending in the queue,
> postponing the PS logic helps to avoid redundant queue stops. Since, I
> could not find any other way in mac80211 to see if the driver has not
> completed the transmission of any frame, a new API to check for
> pending frames is used. When power save is enabled by default and in a
> noisy environment, this API certainly helps in improving the average
> throughput. Any other idea?

I'm not sure I understand. Where does the 100ms come from? This code
flushes the TX queues, which can take as much time as it wants, no? How
does it break applications?

I'll agree that entering powersave is pointless if that means you won't
be able to transmit all frames. It seems to me that maybe instead we
should give flush() a timeout, and if it can't complete in that time, we
can postpone the powersave then?

johannes

