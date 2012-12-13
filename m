Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2LMOBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:40 -0500
Message-ID: <1355407319.9463.4.camel@jlt4.sipsolutions.net> (sfid-20121213_160941_819274_B904BC9F)
Subject: Re: Re: adding ba_policy member in drv_ampdu_action op - request
 information
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 15:01:59 +0100
In-Reply-To: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com>
References: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vivek,

> if you are referring to the addba-request to transmit a ADDBA with 
> delayed block ack, yes, i accept what you have stated. but, then we 
> would need to support delayed block ack on the TX.
> 
> for my query, i was thinking more with respect to the receive side of 
> an AP.

Ah, ok.

> if, let us say a particular station is capable of delayed block ack 
> which might not be a linux station(presently it seems, linux box will 
> only pursue immediate block ack), then on receive of a block ack 
> request, the lower layer can just send an ack if the policy is known to 
> be delayed block ack.

Right now, a mac80211-based station should probably never even advertise
that it is delayed-BA capable since it won't correctly be handled.
Therefore, any other station must not ask for a delayed-BA session in
its AddBA request. And in fact, ieee80211_process_addba_request() drops
frames that ask for delayed BA.

So I guess what you're really saying is that you want to implement
delayed BA and address the todo item in
ieee80211_process_addba_request() that says:

        /* XXX: check own ht delayed BA capability?? */

i.e. add a check here for our own capability and add a new parameter to
let the driver know...

Overall that seems reasonable.

johannes

