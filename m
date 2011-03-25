Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1CYNFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 09:05:07 -0400
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201103251355.55824.helmut.schaa@googlemail.com>
References: <201103232358.29966.helmut.schaa@googlemail.com>
	 <201103251208.22473.helmut.schaa@googlemail.com>
	 <1301052224.3827.2.camel@jlt3.sipsolutions.net>
	 <201103251355.55824.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 14:06:55 +0100
Message-ID: <1301058415.20631.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-25 at 13:55 +0100, Helmut Schaa wrote:

> So far the tx status as returned by the device look correct. I printed the
> sequence numbers of failed AMPDU subframes and had a second device capturing
> the traffic and compared them.
> 
> But I noticed that there still appear holes from time to time that cause the
> strange Intel driver stuck problem (which is really really strange and IMHO
> the driver has a problem too). And it is not necessarily PS related.
> 
> Johannes, what happens if a frame gets dropped on its way though the tx path
> after getting a seqnr assigned? That would cause a hole in the sequence number
> series without the chance to get a IEEE80211_TX_STAT_AMPDU_NO_BACK tx status.

Yeah that's correct, try not to do that :) It's one of the reasons the
Intel driver assigns its own sequence numbers to AMPDU frames (the other
being some odd seqno/queue place match requirement.)

johannes

