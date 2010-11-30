Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:36371 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0K3QfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 11:35:05 -0500
Date: Tue, 30 Nov 2010 17:34:57 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v4] mac80211/rt2x00: add ieee80211_tx_status_ni()
Message-ID: <20101130163457.GA4647@sig21.net>
References: <20101129145439.GA31910@sig21.net>
 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
 <20101129152735.GA32319@sig21.net>
 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
 <20101129155126.GA32482@sig21.net>
 <1291046320.3532.6.camel@jlt3.sipsolutions.net>
 <20101129161316.GA32760@sig21.net>
 <20101130154923.GA4618@sig21.net>
 <1291132380.3624.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291132380.3624.22.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 04:53:00PM +0100, Johannes Berg wrote:
> On Tue, 2010-11-30 at 16:49 +0100, Johannes Stezenbach wrote:
> 
> >   * This function may not be called in IRQ context. Calls to this function
> >   * for a single hardware must be synchronized against each other. Calls
> > - * to this function and ieee80211_tx_status_irqsafe() may not be mixed
> > - * for a single hardware.
> > + * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
> > + * may not be mixed for a single hardware.
> 
> I'm ok with this, although technically you can mix
> ieee80211_tx_status_ni() and ieee80211_tx_status(), just not either or
> both of them with _irqsafe().

I copied these from ieee80211_rx() etc. since I wasn't sure if there's
not some subtlety I didn't get.  One can mix ieee80211_rx() and
ieee80211_rx_ni(), too, right?


Thanks
Johannes
