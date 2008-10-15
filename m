Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42789 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYJOPqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 11:46:13 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224019662.3027.13.camel@johannes.berg>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 17:46:49 +0200
Message-Id: <1224085609.4764.18.camel@californication> (sfid-20081015_174621_240727_0D78DE9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > That doesn't sound like quite the correct behavior.  If a channel is
> > > > excluded for regulatory reasons, then I suspect that should govern
> > > > everyone.  But if one card just doesn't support a band, I don't see
> > > > why any other cards should be limited by that.
> > > > 
> > > > Did I miss something?
> > > 
> > > Well, the thing is that the iwlwifi drivers pretend to know the
> > > regulatory domain; thus when a single-band card registers the regulatory
> > > domain, it gets set to just a domain with the single band.
> > 
> > Ah, now I see what this is about...thanks!
> > 
> > Should there be an "I make no representation of authority" flag in
> > the regulatory maps?
> 
> The only reasonable solution I can come up with is have it make separate
> hints for 2.4 and 5 GHz and then a single-band card won't say anything
> about 5 GHz so the dual-band gets to set that part. But OTOH I don't see
> a reasonable use-case for this whole thing so far---we really only added
> this after discussions with Marcel at OLS so embedded systems can
> function w/o crda, but who would build an embedded system with two
> different cards like that?

and we need to keep it this way. For example the first card can be a
dual-band card, but the EEPROM value restricts it one band. That might
be by choice. Then attaching a second card, we can't just extend it and
let this card go ahead and use the second band.

The only valid solution might be switching cards. So if the first card
gets removed we can take the full regulatory domain of the second one,
but when does this happen at runtime.

Regards

Marcel


