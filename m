Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1KNPh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 10:37:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RPybc-0000uq-9I
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 16:37:56 +0100
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net> (sfid-20111109_140902_212963_943EDBDE)
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 (sfid-20111109_140902_212963_943EDBDE)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 16:37:21 +0100
Message-ID: <1321285041.10264.14.camel@jlt3.sipsolutions.net> (sfid-20111114_163801_419252_45F674FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another thought that crossed my mind is how to handle off-channel TDLS.
I'm sure it'll become a requirement fairly soon, and I think we'll want
to design it into the stack.

I wish I could gather a few people into a room and sit there for a few
days brainstorming how it should look like (and how to implement
backward compatibility!) .... :-)

Anyway so my thought about off-channel TDLS was -- should we maybe
assign a channel to each station? Obviously each station associated to
an AP would have the same channel. That might make channel switching
(CSA) a little interesting, but hey ...

In our device we'll probably not handle it this way, but it seems like
the best abstraction?

Also I think we should probably have some explicit channel handling. I'm
not thinking about scanning/off-channel operations but about actual use
of the channel. There could be some weight requests for the different
channels depending on airtime needs, but ultimately the driver will
probably have to make the timing decisions and will communicate that up
to make negotiation between devices possible for this. NoA might be
handled in the driver right now, but I think TDLS negotiation for
channels would not be, and there you need timings...

johannes


