Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40468 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYJOR2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:28:22 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224086490.735.8.camel@johannes.berg>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)  <1223975972.10113.20.camel@johannes.berg>
	 <1224034856.24677.9.camel@debian.sh.intel.com>
	 <1224085845.4764.23.camel@californication>
	 <1224086490.735.8.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 19:29:00 +0200
Message-Id: <1224091740.28173.13.camel@californication> (sfid-20081015_192826_211698_34D1529A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Let's use the solution at this time. Just a notion that the regdomain in
> > > kernel doesn't sort out very well in some circumstance without user
> > > intervention.
> > 
> > that is what Johannes and I agreed on. We do have to make this work when
> > no userspace is present or is limited due to the design of the embedded
> > system in question. In that case the first regulatory hint wins.
> 
> Yeah, we have to let one of them win, unless we want to add the
> complexity with per-band hints as discussed in the other part of the
> thread.
> 
> > Johannes, we could just add a kernel warning if we have mismatched
> > regulatory hints and userspace was not involved until now. So at least
> > it shows up in dmesg and can be debugged easily if needed.
> 
> We can probably do that, yeah, though we'd have to get the conditions
> right to avoid showing that whenever you plug in a USB device to a
> laptop that already has wireless built-in.

I think it is fine to do so. Since plugging in an USB wireless card is
expected to work and if we limit it, lets give the user at least some
way to figure out why it is limited.

Especially when your internal one is a BG-card and you external one is
an A-card only (or combo). And you put it in to just access an
A-network.

Regards

Marcel


