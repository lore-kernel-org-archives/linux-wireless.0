Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42598 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750806AbXLJHpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 02:45:01 -0500
Subject: Re: [RFC/T][PATCH v2 2/3] rc80211-pid: introduce PID sharpening
	factor
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071210082154.015f6e6a@morte>
References: <20071209211547.2d7fca32@morte> <20071209212133.43030d03@morte>
	 <1197239361.7543.17.camel@localhost> <20071210003120.0078db1d@morte>
	 <1197244416.7543.27.camel@localhost> <20071210032811.5cea4909@morte>
	 <1197268081.7490.10.camel@localhost>  <20071210082154.015f6e6a@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 08:44:56 +0100
Message-Id: <1197272696.7490.31.camel@localhost> (sfid-20071210_074507_588948_FF59697A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 08:21 +0100, Stefano Brivio wrote:
> On Mon, 10 Dec 2007 07:28:01 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > > -	/* If no frames were transmitted, we assume the old sample is
> > > -	 * still a good measurement and copy it. */
> > > -	if (spinfo->tx_num_xmit == 0)
> > > -		pf = spinfo->last_pf;
> > 
> > Please don't remove this check. We can never know when anybody starts
> > calling rate_control_pid_sample() without packets transmitted. Then it's
> > good to have it, else we divide by zero in the next line.
> 
> But, as you said, rate_control_pid_sample() only gets called by
> rate_control_pid_tx_status(). There, spinfo->tx_num_xmit always get
> increased. The only other spot where spinfo->tx_num_xmit gets changed is in
> rate_control_pid_sample(), where we set it to 0 after that that division
> gets done, and we obviously change its value after having been called by
> rate_control_pid_tx_status(). So, it always get increased before the
> division, and it's never set to a negative value. Therefore, I assume that
> it will never be zero in the division. Am I wrong?

You're totally right. But IMHO it's nicer to be a little defensive here.
You never know what happens to your code in the future. Just imagine
somebody coming up with: Hey, let's use a timer-based approach for
sampling. Ok, that's easy to do, just call sample() every time the timer
expires. And whoops, there's the division by zero when no packets are
transmitted...

Mattias

