Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCNRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:17:19 -0500
Message-ID: <1393852634.10039.10.camel@jlt4.sipsolutions.net> (sfid-20140303_141722_296697_BD683B95)
Subject: Re: [PATCH v1 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ
 into info->control.flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Mon, 03 Mar 2014 14:17:14 +0100
In-Reply-To: <214A2CB4-EC3E-4434-AEA4-92956A149C73@net.t-labs.tu-berlin.de>
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393164527-13800-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1393244624.4190.8.camel@jlt4.sipsolutions.net>
	 <23FA0097-F436-4FD7-B076-44EB35CDE9FF@net.t-labs.tu-berlin.de>
	 <1393340740.4170.5.camel@jlt4.sipsolutions.net>
	 <214A2CB4-EC3E-4434-AEA4-92956A149C73@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-28 at 15:27 +0100, Thomas Hühn wrote:

> > Right, but if IEEE80211_TX_CTL_ASSIGN was set then it also isn't
> > cleared.
> 
> So the standard conform behavior should be to re-use the same sequno in case of a software retry ?

Technically, I think that's probably what should happen. However, the
implementation of that is practically impossible since in many cases the
firmware may have assigned a sequence number. Drivers will typically not
assign that number back, if they even know it.

> I could re-assign the flag IEEE80211_TX_CTL_ASSIGN_SEQ when a software retry happens by add
> a test to function ieee80211_handle_filtered_frame. Something like:
> 	 if (!ieee80211_is_data_qos(hdr->frame_control) || is_multicast_ether_addr(hdr->addr1)) {
> 		/* driver should assign sequence number */
> 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
> 	}
> 
> Would this be right ?

No, clearly not, this isn't the same set of conditions. Even if it were,
though, I'd hate to duplicate them here since that just causes a
maintenance nightmare.

> > But now the frame might not have *any* sequence number assigned at all,
> > if e.g. the firmware assigns sequence numbers and they're not written
> > back to the frame. Thus I think you're losing the entire sequence number
> > assignment in this case.
> > 
> 
> If I re-assign the IEEE80211_TX_CTL_ASSIGN_SEQ flag for software retries, than drivers
> that assigned a sequence number in the first try, could probably assign a new one. Would that
> be ok ?

That's what we have. It's debatable and not necessarily
standard-conformant, but I don't think a little cleanup patch like yours
should be allowed to change it.

johannes

