Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42805 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYJOPuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 11:50:08 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224034856.24677.9.camel@debian.sh.intel.com>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)  <1223975972.10113.20.camel@johannes.berg>
	 <1224034856.24677.9.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 17:50:45 +0200
Message-Id: <1224085845.4764.23.camel@californication> (sfid-20081015_175014_345172_45590549)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> > > Does below scenario an expected behaviour?
> > > 
> > > 0. A system with iwl3945 BG card and iwl4965 AGN card.
> > > 1. insmod iwl3945 -> regulatory_hint(, 99, rd) return 0;
> > > 2. insmod iwl4965 -> regulatory_hint(, 99, rd2) return -EALREADY;
> > > 3. iwl4965 has no A band support!
> > 
> > Yeah, I think this is expected, and the solution is to install crda and
> > iw and set the regulatory domain manually to whatever country you're in
> > rather than your cards SKU.
> 
> Let's use the solution at this time. Just a notion that the regdomain in
> kernel doesn't sort out very well in some circumstance without user
> intervention.

that is what Johannes and I agreed on. We do have to make this work when
no userspace is present or is limited due to the design of the embedded
system in question. In that case the first regulatory hint wins.

Johannes, we could just add a kernel warning if we have mismatched
regulatory hints and userspace was not involved until now. So at least
it shows up in dmesg and can be debugged easily if needed.

Regards

Marcel


