Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaBYPFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:05:51 -0500
Message-ID: <1393340740.4170.5.camel@jlt4.sipsolutions.net> (sfid-20140225_160554_666436_15E5F332)
Subject: Re: [PATCH v1 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ
 into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Tue, 25 Feb 2014 16:05:40 +0100
In-Reply-To: <23FA0097-F436-4FD7-B076-44EB35CDE9FF@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393244624.4190.8.camel@jlt4.sipsolutions.net>
	 <23FA0097-F436-4FD7-B076-44EB35CDE9FF@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 14:31 +0100, Thomas Hühn wrote:

> > I'm not convinced this patch is correct, so you need to convince me.
> > What happens to software-retry frames? They probably *shouldn't* get a
> > new seqno, but if the driver doesn't modify the SKB (say because
> > hardware/firmware assigns it) then this is certainly not right.
> 
> As far as I can see, software-retry frames get in status.c the flag
> IEEE80211_TX_INTFL_RETRANSMISSION
> assigned (in function ieee80211_handle_filtered_frame). And this flag
> prevents in function
> invoke_tx_handlers() the call of ieee80211_tx_h_sequence(), so there
> is not new seqno assigned in case of a software-retry within tx.c.

Right, but if IEEE80211_TX_CTL_ASSIGN was set then it also isn't
cleared.

> But in case of a software retry there is info->control set to zero.
> After I would move IEEE80211_TX_CTL_ASSIGN_SEQ into
> info->control.flags this flag is zero.
> Hence also drivers do not assign a new sequence number.

But now the frame might not have *any* sequence number assigned at all,
if e.g. the firmware assigns sequence numbers and they're not written
back to the frame. Thus I think you're losing the entire sequence number
assignment in this case.

johannes

