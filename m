Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:56422 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754717AbXK0PkS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 10:40:18 -0500
Date: Tue, 27 Nov 2007 16:35:20 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
 estimate for rc80211_simple
Message-ID: <20071127163520.028f91fb@morte> (sfid-20071127_154053_472363_BBE2D65C)
In-Reply-To: <1196112605.8318.6.camel@localhost>
References: <1196112605.8318.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Nov 2007 22:30:05 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> This changes rc80211_simple failed frame percentage estimation to use an
> exponential moving average method. Failed frames percentage is sampled
> over time and a smoothed average is computed. This average is examined
> periodically and the rate adjusted eventually.

This can be seen as a particular example of a PID controller [1]. It's
actually a PI controller, with no derivative terms in it. It could be
interesting to implement a regular PID controller.

This is clearly a MIMO model, with the setpoints being a reasonable value
of TX failures and the highest achievable rate, the process input being the
bitrate and the process output being TX failures and successes; and
obviously, the big issue being the implementation without floating-point.
Thus, with some tuning, you could probably get a very good rate control
algorithm.

I just wanted to share this thought ATM, but I'll try to elaborate more if I
happen to have some spare time.

[1] http://en.wikipedia.org/wiki/PID_controller


-- 
Ciao
Stefano
