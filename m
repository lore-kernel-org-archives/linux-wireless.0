Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52986 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2GXT2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 15:28:48 -0400
Date: Tue, 24 Jul 2012 12:28:45 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Hong Wu <Hong.Wu@dspg.com>
Subject: Re: [PATCH] wireless: reg: restore previous behaviour of
 chan->max_power calculations
Message-ID: <20120724192845.GB31108@tux> (sfid-20120724_212852_695414_C5DDB520)
References: <20120724063538.GB2265@redhat.com>
 <1343141586.4415.40.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1343141586.4415.40.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2012 at 04:53:06PM +0200, Johannes Berg wrote:
> On Tue, 2012-07-24 at 08:35 +0200, Stanislaw Gruszka wrote:
> > commit eccc068e8e84c8fe997115629925e0422a98e4de
> > Author: Hong Wu <Hong.Wu@dspg.com>
> > Date:   Wed Jan 11 20:33:39 2012 +0200
> > 
> >     wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit pow
> > 
> > changed the way we calculate chan->max_power as min(chan->max_power,
> > chan->max_reg_power). That broke rt2x00 (and perhaps some other
> > drivers) that do not set chan->max_power. It is not so easy to fix this
> > problem correctly in rt2x00.
> > 
> > According to commit eccc068e8 changelog, change claim only to save
> > maximum regulatory power - changing setting of chan->max_power was side
> > effect. This patch restore previous calculations of chan->max_power and
> > do not touch chan->max_reg_power.
> 
> Applied, but I'll wait for Luis's comments before I push it out.

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Makes sense, thanks for catching this.

  Luis
