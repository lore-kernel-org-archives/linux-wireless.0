Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LNIV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 03:21:28 -0500
Subject: Re: [RFC] mac80211: Change BA timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19719.10364.75022.257291@gargle.gargle.HOWL>
References: <19719.8288.322475.954293@gargle.gargle.HOWL>
	 <1292312835.3569.5.camel@jlt3.sipsolutions.net>
	 <19719.10364.75022.257291@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 09:21:26 +0100
Message-ID: <1292314886.3569.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-14 at 13:49 +0530, Sujith wrote:
> Johannes Berg wrote:
> > On Tue, 2010-12-14 at 13:14 +0530, Sujith wrote:
> > > The BlockAck session timout value is currently an arbitrary 5000.
> > > This results in BA sessions being created and torn down incessantly
> > > when mac80211 is used with a driver (say ath9k) in AP mode.
> > > 
> > > The 802.11 standard doesn't specify any default value for the timeout field.
> > > And there is no benefit to be gained by tearing down BA sessions and
> > > recreating them. The current value of 5000 doesn't cause any problems,
> > > but it is hard to find an AP/STA in the field that uses a non-zero timeout.
> > 
> > Please make it configurable in the request API. Each session consumes
> > one of a very limited number of hardware queues on iwlwifi, and once we
> > go to having multiple connected stations to it as an AP, it would be
> > good to time out idle sessions.
> 
> Something like this ?

[snip]

yeah, looks good, thanks

johannes

