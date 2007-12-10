Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41172 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753680AbXLJU4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 15:56:36 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071210090323.47d657e6@morte>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost> <20071210002158.654ed960@morte>
	 <1197269336.7490.25.camel@localhost>  <20071210090323.47d657e6@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 21:56:32 +0100
Message-Id: <1197320192.7493.10.camel@localhost> (sfid-20071210_205640_487958_DF3FFC2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 09:03 +0100, Stefano Brivio wrote:
> > However, the issue here is quite subtle: Currently, we don't know
> > whether the frames that we receive status about in tx_status() were
> > actually sent with the rate as decided by the algorithm. This is
> > something I have on my list, but I currently don't know how to address
> > it properly. Comments welcome.
> 
> Could you elaborate here? I miss the point (i.e. what's the problem here).

Sometimes, the stack sends frames at different rates than what was
decided by the rate control algorithm (there are several situations in
which this can happen, e.g. an AP only allowing 802.11b rates, rts/cts
frames, maybe more). But still, the tx status is reported back to the
rate control algorithm as for normal frames. Now the rate control
algorithm just doesn't care and accounts the tx status to the wrong
rate. This is clearly suboptimal. I cannot estimate how much impact this
behaviour has. However, it shouldn't be hard to improve the situation
either by reporting back to the rate control algorithm on which rate the
frame handed to tx_status() was actually transmitted, so it can decide
itself what to do about this (this is my preferred solution). Or you
could just have the stack don't call tx_status() for frames that were
transmitted on another rate.

If you like to work on this, go ahead, I'm busy with my graphing stuff.

Mattias

