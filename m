Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17391 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYJPAo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 20:44:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 17:44:56 -0700
Date: Wed, 15 Oct 2008 10:44:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081015174447.GF15902@tesla> (sfid-20081016_024500_533013_58ECFC09)
References: <1224086374.735.4.camel@johannes.berg> <1224091577.28173.9.camel@californication> <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> <1224092868.28173.21.camel@californication> <20081015112517.GF6509@tesla> <1224098748.28173.32.camel@californication> <20081015131622.GH6509@tesla> <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com> <20081015170830.GA15902@tesla> <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 05:35:44PM -0700, Tomas Winkler wrote:
> On Wed, Oct 15, 2008 at 7:08 PM, Luis R. Rodriguez
> > The issue was your single band cards do not store 5 GHz band regulatory
> > information. Is this MOW1 or MOW2?
> 
> Don't understand the question, the 5GHz channels are disabled that's
> all you can read from there.

Oh OK so its not just MOW1 and MOW2 but you also *do* take into account
the card's capabilities.

> > It certainly helps more understand your situation. I had no idea
> > of MOW1 and MOW2. Can this be documented as part of the
> > regulatory_hint() code changes which will be added?
> 
> I've just checked current docs and from 5000 on inclusively there are
> only 3 SKU's MOW, ABG (no N) and BG. All others were depreciated.

Interesting.. Are these SKUs also used on other platforms as well, say
for Windows?

Anyway since you only have 3 this should be very simple to resolve...
Just add the 5 GHz frequency ranges you always support. Obviously the BG
card will not be able to make use of them :)

  Luis
