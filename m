Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:35268 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751442AbXLJH2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 02:28:22 -0500
Date: Mon, 10 Dec 2007 08:21:54 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH v2 2/3] rc80211-pid: introduce PID sharpening
 factor
Message-ID: <20071210082154.015f6e6a@morte> (sfid-20071210_072826_412849_2AE5469C)
In-Reply-To: <1197268081.7490.10.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209212133.43030d03@morte>
	<1197239361.7543.17.camel@localhost>
	<20071210003120.0078db1d@morte>
	<1197244416.7543.27.camel@localhost>
	<20071210032811.5cea4909@morte>
	<1197268081.7490.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 07:28:01 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> > -	/* If no frames were transmitted, we assume the old sample is
> > -	 * still a good measurement and copy it. */
> > -	if (spinfo->tx_num_xmit == 0)
> > -		pf = spinfo->last_pf;
> 
> Please don't remove this check. We can never know when anybody starts
> calling rate_control_pid_sample() without packets transmitted. Then it's
> good to have it, else we divide by zero in the next line.

But, as you said, rate_control_pid_sample() only gets called by
rate_control_pid_tx_status(). There, spinfo->tx_num_xmit always get
increased. The only other spot where spinfo->tx_num_xmit gets changed is in
rate_control_pid_sample(), where we set it to 0 after that that division
gets done, and we obviously change its value after having been called by
rate_control_pid_tx_status(). So, it always get increased before the
division, and it's never set to a negative value. Therefore, I assume that
it will never be zero in the division. Am I wrong?


--
Ciao
Stefano
