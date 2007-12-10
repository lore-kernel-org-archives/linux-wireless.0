Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45354 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751540AbXLJH3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 02:29:51 -0500
Date: Mon, 10 Dec 2007 08:23:28 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH v2 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210082328.50d1ad7f@morte> (sfid-20071210_072953_502653_5D1F7D9B)
In-Reply-To: <1197269480.7490.27.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210002158.654ed960@morte>
	<20071210032421.7017c681@morte>
	<1197269480.7490.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 07:51:20 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> > +static inline int rate_control_pid_r_to_i(struct rc_pid_rateinfo *r, int rate,
> > +					  int l)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < l; i++)
> > +		if (r[i].index == rate)
> > +			break;
> > +
> > +	return i;
> > +}
> 
> Isn't the store-direct-rinfo-indices approach nicer? Why did you decide
> for the index conversion function in favour of storing direct indices?

Yesterday there was a reason, now I just forgot it. If I can't recall about
it within tomorrow, I'll switch to the other approach. ;)


-- 
Ciao
Stefano
