Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-73.dex002.intermedia.net ([64.78.20.109]:19819 "EHLO
	DHOST002-73.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969680AbXFHSeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 14:34:04 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 8 Jun 2007 11:34:46 -0700
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070608183446.GJ14078@devicescape.com>
References: <200706072205.27902.flamingice@sourmilk.net> <20070608112146.2df3608c@griffin.suse.cz> <20070608145821.GD14078@devicescape.com> <43e72e890706081112k76e17827t4c66dbccdcee0e03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890706081112k76e17827t4c66dbccdcee0e03@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 02:12:57PM -0400, Luis R. Rodriguez wrote:
> On 6/8/07, Jouni Malinen <jkm@devicescape.com> wrote:
> >There are some odd cases, where disabling the lowest supported rate may
> >even be required due to regulatory rules..

> Just curious -- are you aware of a regulatory domain where this is the
> case? Who defines those rules? For example, AFAICT FCC only talk about
> power, and spectrum ranges. Where would I even look for these type of
> restrictions?

I don't remember all the details, but one case I've heard of was about
a rule that specified high bandwidth wireless operations and what
exactly would be high enough to be acceptable. And no, this was not
from FCC. Unfortunately, I do not have any good pointers for where to
look for this type of restrictions in an easy to use form (as in
something that I could easily understand ;-).

One related issue is the requirement for not transmitting continuously
for longer than a quite short time period before sensing the medium
again (this is from Japan). This may require at least fragmentation
based on TX rate (i.e., if low rate is used, fragmentation threshold
needs to be set lower) and in some cases, it may just be easier to drop
the lowest TX rates completely to avoid frames that may take long time
to transmit.

-- 
Jouni Malinen                                            PGP id EFC895FA
