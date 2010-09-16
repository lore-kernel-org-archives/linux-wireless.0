Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0IPT4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:56:09 -0400
Subject: Re: [PATCH] mac80211: Filter ProbeReq SuppRates based on TX rate
 mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100916195441.GB25174@jm.kir.nu>
References: <20100828163610.GA23426@jm.kir.nu>
	 <1283154490.3691.2.camel@jlt3.sipsolutions.net>
	 <20100916195441.GB25174@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 21:55:58 +0200
Message-ID: <1284666958.3731.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 09:54 -1000, Jouni Malinen wrote:
> On Mon, Aug 30, 2010 at 09:48:10AM +0200, Johannes Berg wrote:
> > On Sat, 2010-08-28 at 19:36 +0300, Jouni Malinen wrote:
> > > If the TX rate set has been masked, the removed rates can also be
> > > removed from the Supported Rates and Extended Supported Rates IEs in
> > > Probe Request frames.
> > 
> > Technically, the probe request frame indicates RX bitrates. I don't
> > really mind using the TX bitrates as well since typically I do think you
> > probably want them to be symmetric, but shouldn't that come with nl80211
> > updates etc. since that's all saying TX_BITRATES?
> 
> This change should really not be needed in the first place, but
> unfortunately, P2P requires this for a compliant implementation.. The
> field is really "Supported Rates", i.e., it would be used for both TX
> and RX. I don't see any real point in configuring RX rates (i.e., make
> hw not receive frames on one or more of the supported rates), so the TX
> rate mask is the only reasonable configuration mechanism for this.
> 
> The minimum requirement (for P2P compliance) is to just remove rates 1,
> 2, 5.5, 11 Mbps from the list, so we could also add something to disable
> 802.11b rates in general if a different command would be desired.

Yes, so it's not really "RX rates" but "advertised RX rates". I just
think that this fact should be made apparent in the documentation?

johannes

