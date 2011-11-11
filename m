Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab1KKNP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 08:15:28 -0500
Date: Fri, 11 Nov 2011 14:16:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: off- & multi-channel operation
Message-ID: <20111111131632.GA2331@redhat.com> (sfid-20111111_141531_900578_9C19DF73)
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 09, 2011 at 02:08:54PM +0100, Johannes Berg wrote:
> How do we want to handle these things? I'm sure I want the drivers to
> handle multi-channel operation fairly transparently, with multiple
> (hardware) queues (in the driver), so mac80211 doesn't have to
> start/stop the queues continuously and can just transmit on that
> interface, the frame might only go out a bit later.

I do not quite understand how separate tx queues could help here, because
we not only have to transmit off-channel but also receive data. For me
simple solution would be adding new functions on top of
ieee80211_tx_skb, which will just queue skb's if we are not on operating
channel at present, and send them lately when we come back.

Or perhaps you are talking about separate tx and rx queues, that could
eventually work, but driver still should know how long to stay off-channel
to receive all needed frames. 

Stanislaw
