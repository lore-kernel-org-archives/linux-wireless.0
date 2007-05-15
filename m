Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-17.dex002.intermedia.net ([64.78.21.83]:5493 "EHLO
	dhost002-17.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbXEONDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 09:03:23 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Tue, 15 May 2007 06:03:40 -0700
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: fail back to use associate from reassociate
Message-ID: <20070515130340.GA25641@devicescape.com>
References: <20070509054152.GA30839@mail.intel.com> <20070509152855.GB941@devicescape.com> <1178767250.3045.36.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178767250.3045.36.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2007 at 11:20:50AM +0800, Zhu Yi wrote:

> I take it an error handling code. When an AP denies a STA reassociation
> request with the reason "there is no previous association, why do you
> send reassociation request to me?", this is an indication for the STA to
> switch to association request and retry. Currently, mac80211 just try
> reassociation over and over. The result is it can never associate with
> the AP.

OK. This sounds reasonable. I went through the IEEE 802.11 standard and
it does not seem to describe this part of re-association process in any
level of detail apart from allocation a status code for reporting
failures to validate association status.

> In .11r, can AP reject reassociation request if there is no previous
> association from the same STA?

.11r does not use this status code. I was concerned about this in
general, i.e., anything that converts re-association to association
sounds somewhat undesired, but it looks like this particular status code
could be the only exception for this. I still don't see how the AP in
this case would have known about the association status for the full ESS
(since I don't see how it would know that it is the only AP in the ESS).
Anyway, non-AP STA does not have enough context to determine what
exactly happen, so it cannot really do much more than either stop trying
to re-associate or try to associate what is what your change is
proposing ot do.

-- 
Jouni Malinen                                            PGP id EFC895FA
