Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32495 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZFRS20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 14:28:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 11:28:30 -0700
Date: Thu, 18 Jun 2009 11:28:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: reinette chatre <reinette.chatre@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching
	bands  and not scanning
Message-ID: <20090618182831.GA2028@tesla>
References: <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com> <1244667817.20900.402.camel@rc-desk> <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com> <1244668077.4706.4.camel@johannes.local> <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com> <43e72e890906101544i22bacc8fxa0a7d045eea50280@mail.gmail.com> <43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com> <1244753407.20900.456.camel@rc-desk> <20090618150119.GD2738@tuxdriver.com> <1245340021.24303.302.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1245340021.24303.302.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 08:47:01AM -0700, reinette chatre wrote:
> Hi John,
> 
> On Thu, 2009-06-18 at 08:01 -0700, John W. Linville wrote:
> > On Thu, Jun 11, 2009 at 01:50:07PM -0700, reinette chatre wrote:
> >
> > > I ran the steps to reproduce on a kernel that is the latest
> > > wireless-testing + "mac80211: disconnect when user changes channel" +
> > > "iwlwifi: remove rs_get_rate workaround". Unfortunately I still get the
> > > rs_get_rate warning.
> >
> > Should I merge the ath9k rate series w/o "iwlwifi: remove rs_get_rate
> > workaround"?
> 
> The later patch "mac80211: add helper for management / no-ack frame rate
> decision" also touches iwlwifi and assumes that "iwlwifi: remove
> rs_get_rate workaround" has been applied.
> 
> I do not know if Luis would want that patch to go in because the warning
> we get may not be specific to iwlwifi. If you do want that to go in then
> please remove the iwlwifi bits.

I don't believe the warning you got were iwlwifi specific, I confirmed it and
I was able to reproduce with ath9k and I also sent a patch to correct it. I'd hate
to see a work around be kept for them and the issue not addressed properly,
which is what this has been trying to address.

Mind you the patch I sent conflicts with johills patch but I figured we can
just implement a proper patch to fix that warning afterwards.

  Luis
