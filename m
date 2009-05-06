Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58415 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZEFRbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 13:31:13 -0400
Date: Wed, 6 May 2009 13:25:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
	on 802.11a capable card
Message-ID: <20090506172513.GB30070@tuxdriver.com>
References: <1241626486.30590.13.camel@mj> <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 06, 2009 at 12:36:13PM -0400, Bob Copeland wrote:
> On Wed, May 6, 2009 at 12:14 PM, Pavel Roskin <proski@gnu.org> wrote:
> > Hello!
> >
> > If I scan by "iw dev wlan0 scan" while sending data through the
> > interface, I get a BUG in net/mac80211/tx.c:
> 
> Agreed... Also I think the same thing happens for rx for ath5k,
> explaining the 'unknown rate index' warnings (sc->curband changes
> during scan but we process a beacon from 2ghz band, that one at
> least just needs some synchronization in the driver).

Ah, that could be -- I sure am tired of reading bug reports about
that...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
