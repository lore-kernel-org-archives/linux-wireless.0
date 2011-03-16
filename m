Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1CPKIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 06:08:19 -0400
Subject: Re: [PATCH] mac80211: fix comment regarding aggregation buf_size
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: John Linville <linville@tuxdriver.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
References: <1300268390.3761.14.camel@jlt3.sipsolutions.net>
	 <AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 11:09:55 +0100
Message-ID: <1300270195.3761.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 02:47 -0700, Daniel Halperin wrote:

> <dan starts here>
> 
> > + *     possible with a buf_size of 8:
> > + *      - TX: 1.....7
> > + *      - RX: 2.....7 (lost frame #1),
> > + *      - TX:         89...1...
> > + *     which is invalid since #1 was now re-transmitted well past the
> > + *     buffer size of 7. The correct way to retransmit #1 would be:
> > + *      - TX:         1       or
> > + *      - TX:         18
> > + *     though the standard allows:
> > + *      - TX:         81
> > + *     The following might happen, but will violate buffering assumptions as above if frame 1 is lost again
> > + *      - TX:         189.....

Oh, oops, yes you're right. Will respin the patch.

johannes

