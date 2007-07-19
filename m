Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:62801 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761950AbXGSVTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 17:19:45 -0400
Date: Thu, 19 Jul 2007 23:19:43 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH 1/2] zd1211rw-mac80211: return hardware specific tx rate code for rx status
Message-ID: <20070719211943.GA17387@deine-taler.de>
References: <20070611103828.961999956@warmcat.com> <20070611103914.481787013@warmcat.com> <20070719191002.GB6603@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070719191002.GB6603@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-19 15:10 John W. Linville wrote:

> On Mon, Jun 11, 2007 at 11:38:29AM +0100, andy@warmcat.com wrote:
> > zd1211rw-mac80211 uses different hardware-specific codings to talk about
> > rates when doing transmit and receive.  Because mac80211 looks up the rx
> > rate against the rates table used for selecting hardware-specific coding for
> > tx, the rate returned in the rx_status struct needs to be adjusted to use the
> > coding used to hardware-specific tx rates.  This patch performs this adjustment.
> > 
> > Without this patch the radiotap-based monitor stuff reports a "0.0Mbps" rate for
> > all packets from this driver.
> > 
> > CC: Daniel Drake <dsd@gentoo.org>
> > CC: Ulrich Kunitz <kune@deine-taler.de>
> > Signed-off-by: Andy Green <andy@warmcat.com>
> 
> Daniel, Uli -- ack/nak?

John,

NAK. The patch introduces unnecessarily a new function.

I have already the correct patch in the queue:

http://deine-taler.de/git-bin/gitweb.cgi?p=zd1211rw.git;a=commitdiff;h=d635ff55fa76ff36da0b923c680861ccbddf34ad;hp=7e052f8d9f078314f3a3ad4a052e9a6c0e8fcadb

Kind regards,

Uli

-- 
Uli Kunitz
