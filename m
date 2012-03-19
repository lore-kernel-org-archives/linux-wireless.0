Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26216 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2CSFB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 01:01:56 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20326.48447.815801.808651@gargle.gargle.HOWL> (sfid-20120319_060200_135594_1E20E7DF)
Date: Mon, 19 Mar 2012 10:29:43 +0530
To: Adrian Chadd <adrian@freebsd.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 20/40 coexist
In-Reply-To: <CAJ-VmonSYm6G6Y9zkgwFvEQzDx56q=S6-USPkr7To-drMNh5JA@mail.gmail.com>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	<8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	<1332065984.3609.5.camel@jlt3.sipsolutions.net>
	<CAJ-VmomNGku0CNfX+feeeUET4mXEFDj976sSfg-GG-KUSGCWvw@mail.gmail.com>
	<20326.44233.811876.892785@gargle.gargle.HOWL>
	<CAJ-VmonSYm6G6Y9zkgwFvEQzDx56q=S6-USPkr7To-drMNh5JA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> Right, but for AP mode what's involved?
> 
> * Does it send out a CSA to the same channel but different operational
> mode stuff?
> * are all current aggregation sessions maintained, or are they reset
> when a CSA to the same channel is done?
> * What about stuff to do with power saving?

All of the above probably have to be handled. :)
(along with virtual interface management).

> I'm ignoring CWM for now until I've finished off these SMP TX
> aggregation bugs, then I'll sort out channel scanning and power saving
> stuff. That sets all the right "bits" for CWM (ie, being able to queue
> all the frames without flushing them, then restarting the software TX
> queue as needed.) Once that's done, CWM should be:
> 
> * signal stop TX;
> * wait for TX threads, TX completion and TX DMA to complete;
> * signal a rate control change;
> * recalculate the rate control selection for everything in the software queues;
> * restart..

You missed the MAC/PHY update based on the new channel information.
Which is where it gets tricky, since we end up doing a full reset.

Sujith
