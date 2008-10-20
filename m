Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54701 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYJTKiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 06:38:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 03:38:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.24323.743610.871307@gargle.gargle.HOWL> (sfid-20081020_123822_077081_BDBACDCB)
Date: Mon, 20 Oct 2008 16:05:47 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224495531.18024.55.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > HT frames for aggregation enabled STAs are processed in the TX completion path, so
> > they are buffered.
> 
> But couldn't non-HT frames be buffered similarly? Maybe I'm missing one
> of the finer points of the 11n draft?

Probably because 11n aggregation have more rigorous timing requirements
between frames.

> > Makes sense, ath9k currently has a similar set of functions ( pausing/resuming TIDs).
> > How would the pending frames for each TID be managed ?
> > Will the driver be able to pull them as and when needed or would mac80211
> > push them down on checking if the TID is awake ?
> 
> I guess there's no clear answer here. How about "whichever you want"?
> Though I think I prefer pushing them down as that makes the model easier
> to understand. It probably also makes the Intel case easier to
> implement.

A way to pull down buffered frames for each TID (like ieee80211_get_buffered_bc() )
would be really useful for ath9k.

Sujith
