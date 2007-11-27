Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759189AbXK0ViH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 16:38:07 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
	estimate for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20071127163520.028f91fb@morte>
References: <1196112605.8318.6.camel@localhost>
	 <20071127163520.028f91fb@morte>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 22:38:04 +0100
Message-Id: <1196199484.8298.23.camel@localhost> (sfid-20071127_213813_020474_2C0D905C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-11-27 at 16:35 +0100, Stefano Brivio wrote:
> On Mon, 26 Nov 2007 22:30:05 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > This changes rc80211_simple failed frame percentage estimation to use an
> > exponential moving average method. Failed frames percentage is sampled
> > over time and a smoothed average is computed. This average is examined
> > periodically and the rate adjusted eventually.
> 
> This can be seen as a particular example of a PID controller [1]. It's
> actually a PI controller, with no derivative terms in it. It could be
> interesting to implement a regular PID controller.
> 
> This is clearly a MIMO model, with the setpoints being a reasonable value
> of TX failures and the highest achievable rate, the process input being the
> bitrate and the process output being TX failures and successes; and
> obviously, the big issue being the implementation without floating-point.
> Thus, with some tuning, you could probably get a very good rate control
> algorithm.

Good point, I'm not too familiar with control theory, but I'll do some
homework :-)

However, maybe you can answer some questions:

Is it sensible to preprocess (i.e. calculate a smoothed average) the
input data for a PID controller? If so, should we compute a time average
or just average over the last N frames?

Note that the rates (or actually modulations) are not a continuous
entity, but we only have a limited set of choices. Normally, the PID
would output a value from some continuous range. What are good ways to
map the PID controller output to a rate?

Mattias

