Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-59.dex002.intermedia.net ([64.78.21.242]:16986 "EHLO
	dhost002-59.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXFHVpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 17:45:03 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 8 Jun 2007 14:45:34 -0700
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070608214534.GB26702@devicescape.com>
References: <200706072205.27902.flamingice@sourmilk.net> <20070608112146.2df3608c@griffin.suse.cz> <20070608145821.GD14078@devicescape.com> <43e72e890706081112k76e17827t4c66dbccdcee0e03@mail.gmail.com> <20070608183446.GJ14078@devicescape.com> <43e72e890706081310j47ed891cl1ebb132e65517db3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890706081310j47ed891cl1ebb132e65517db3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 08, 2007 at 04:10:10PM -0400, Luis R. Rodriguez wrote:
> On 6/8/07, Jouni Malinen <jkm@devicescape.com> wrote:

> >One related issue is the requirement for not transmitting continuously
> >for longer than a quite short time period before sensing the medium
> >again (this is from Japan).

> Wow, aren't those regulatory requirements breaking the spec? I wonder
> if loading a different rate algorithm depending on regdomain would do
> the job in a case like this.

What do you mean by breaking the spec? Local regulations come first and
whatever is to be used to transmit better comply with those no matter
what the IEEE 802.11 standard says. Just using a different rate
algorithm may not be enough to handle this kind of cases. There needs
to be a way to enforce some rules like the maximum continuous
transmission at a lower layer and somehow adjust the parameters if
needed.

This particular rule may not be too much of an issue for now since it
came up in a case where non-standard TX rate were used (i.e., something
below the minimum used in 802.11a). Anyway, we should try to be able to
handle whatever rules comes up now or in the future. Of course, one way
of handling limitations is not to allow transmissions at all, but that
may not always be the ideal solution.

-- 
Jouni Malinen                                            PGP id EFC895FA
