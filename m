Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:60784 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754334AbXLJVg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 16:36:59 -0500
Date: Mon, 10 Dec 2007 22:30:18 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210223018.2f7a31d1@morte> (sfid-20071210_213702_759822_AE7DFEA9)
In-Reply-To: <1197320192.7493.10.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210002158.654ed960@morte>
	<1197269336.7490.25.camel@localhost>
	<20071210090323.47d657e6@morte>
	<1197320192.7493.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 21:56:32 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Sometimes, the stack sends frames at different rates than what was
> decided by the rate control algorithm (there are several situations in
> which this can happen, e.g. an AP only allowing 802.11b rates, rts/cts

No, wait, to consider rts/cts frames makes sense here, but I'd say that the
same doesn't apply to AP only allowing 802.11b rates, because anyway
non-CCK rates would get excluded from supported rates, and we wouldn't even
map them.

> frames, maybe more). But still, the tx status is reported back to the
> rate control algorithm as for normal frames. Now the rate control
> algorithm just doesn't care and accounts the tx status to the wrong
> rate. This is clearly suboptimal. I cannot estimate how much impact this
> behaviour has. However, it shouldn't be hard to improve the situation
> either by reporting back to the rate control algorithm on which rate the
> frame handed to tx_status() was actually transmitted, so it can decide
> itself what to do about this (this is my preferred solution). Or you
> could just have the stack don't call tx_status() for frames that were
> transmitted on another rate.

Ok, got it. But I would just discard them, I can't think of any
significant measurement on those frames. So I would follow the second
approach here. Or do you have any suggestions on how to consider those
frames?


--
Ciao
Stefano
