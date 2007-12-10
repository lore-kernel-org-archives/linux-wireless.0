Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44251 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170AbXLJAX6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 19:23:58 -0500
Date: Mon, 10 Dec 2007 01:17:38 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210011738.2267cb65@morte> (sfid-20071210_002400_583337_9C4C6E11)
In-Reply-To: <20071210002158.654ed960@morte>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210002158.654ed960@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 00:21:58 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> > > +	/* If we just switched rate, update the rate behaviour info. */
> > > +	if (pinfo->oldrate != sta->txrate) {
> > > +		for (i = 0; i < mode->num_rates; i++)
> > > +			if (rinfo[i].index == pinfo->oldrate)
> > > +				break;
> > > +		for (j = 0; j < mode->num_rates; j++)
> > > +			if (rinfo[j].index == sta->txrate) {
> > > +				rinfo[j].valid = 1;
> > > +				break;
> > > +			}
> > 
> > This is no 3 and 4 of the call sites to the to be written
> > find_index_for_rate() function ;-)
> >
> > Or what about this idea: Store direct indices into the rinfo table, so
> > you needn't convert them back from the mode->rates indexing everywhere.
> 
> This makes sense. Unless you are working to the find_index_for_rate()
> function, which would make more sense.

Eek, sorry, bullshit. I didn't get your point here, I do now. Will write
that function.


--
Ciao
Stefano
