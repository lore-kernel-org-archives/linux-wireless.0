Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:58801 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752042AbbCCIwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:52:31 -0500
Message-ID: <1425372748.17273.6.camel@perches.com> (sfid-20150303_095251_187046_9C700624)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 00:52:28 -0800
In-Reply-To: <1425372295.2450.9.camel@sipsolutions.net>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <1425371858.17273.3.camel@perches.com>
	 <1425372295.2450.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 09:44 +0100, Johannes Berg wrote:
> > > Other than that, I guess I'll apply this, but I really wish there was a
> > > way to distinguish more easily which of these require alignment and
> > > which don't.
> > 
> > My guess is the eth_zero_addr and eth_broadcast functions
> > are always taking aligned(2) arguments, just like all the
> > is_<foo>_ether_addr functions.
> 
> Err, are you serious???

Yes.

> That *clearly* isn't true, and if it was then
> this patch wouldn't be safe at all.

And why is that?

Until patch 1 of this series, eth_zero_addr and
eth_broadcast_addr was just an inline for a memset.

Even after patch 1, it's effectively still memset.

