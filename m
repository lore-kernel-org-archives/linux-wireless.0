Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33874 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYABIpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 03:45:40 -0500
Date: Wed, 2 Jan 2008 08:45:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20080102084532.GA17960@infradead.org> (sfid-20080102_084542_269490_05F66B95)
References: <1198253375.16241.76.camel@johannes.berg> <20071230231120.GB16557@uranus.ravnborg.org> <20071231074536.GA26874@infradead.org> <1199263275.4172.60.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1199263275.4172.60.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 02, 2008 at 09:41:15AM +0100, Johannes Berg wrote:
> 
> > Why don't we just build the rate control algorithms entirely separate
> > useing obj-$(FOO) ?  If they're modular that lets them be their own
> > module, and if they're built-in they'll still go into built-in.o.
> 
> Yeah. Except that they can't be built-in if mac80211 isn't, and we've
> repeatedly had users f' up their installations and bitterly report to us
> that mac80211 doesn't work because no rate control algorithm is
> available so we wanted to force having one built into mac80211.ko unless
> specifically turned off (only with EMBEDDED).

Building an algorithm optionally into mac80211 seems rather odd.  In
case mac80211 the algorithms should be their own modules and you should
use request_module to make sure at least one is loaded.  Or if you
really want to make sure one is alway avaiabable always build the
simplest one directly and unconditionally into mac80211.ko.

> 
> johannes


---end quoted text---
