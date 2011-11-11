Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1KKN0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 08:26:43 -0500
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20111111131632.GA2331@redhat.com>
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 <20111111131632.GA2331@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 14:26:33 +0100
Message-ID: <1321017993.3977.206.camel@jlt3.sipsolutions.net> (sfid-20111111_142646_299566_14E769B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-11 at 14:16 +0100, Stanislaw Gruszka wrote:
> On Wed, Nov 09, 2011 at 02:08:54PM +0100, Johannes Berg wrote:
> > How do we want to handle these things? I'm sure I want the drivers to
> > handle multi-channel operation fairly transparently, with multiple
> > (hardware) queues (in the driver), so mac80211 doesn't have to
> > start/stop the queues continuously and can just transmit on that
> > interface, the frame might only go out a bit later.
> 
> I do not quite understand how separate tx queues could help here, because
> we not only have to transmit off-channel but also receive data. For me
> simple solution would be adding new functions on top of
> ieee80211_tx_skb, which will just queue skb's if we are not on operating
> channel at present, and send them lately when we come back.
> 
> Or perhaps you are talking about separate tx and rx queues, that could
> eventually work, but driver still should know how long to stay off-channel
> to receive all needed frames. 

Well, so usually you'd schedule NoA, or use null data frames to not
receive, etc. Using multiple TX queues would help schedule the TX,
scheduling the RX is a different issue.

johannes

