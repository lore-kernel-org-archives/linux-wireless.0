Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2ITMxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:53:45 -0400
Message-ID: <1348145661.4161.34.camel@jlt4.sipsolutions.net> (sfid-20120920_145353_607695_2F98D912)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <edumazet@google.com>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Date: Thu, 20 Sep 2012 14:54:21 +0200
In-Reply-To: <CANn89iLudX29yU8ziNyN+8gN3b2L55L9m5p6ob_wnfZ3fp_TDg@mail.gmail.com> (sfid-20120920_145113_728996_FFF92D50)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145269.4161.28.camel@jlt4.sipsolutions.net>
	 <CANn89iLksBMJ=Ep+VcPSAOPzqst70hk8hR5=mGte2vSx=49zUA@mail.gmail.com>
	 <1348145450.4161.31.camel@jlt4.sipsolutions.net>
	 <CANn89iLudX29yU8ziNyN+8gN3b2L55L9m5p6ob_wnfZ3fp_TDg@mail.gmail.com>
	 (sfid-20120920_145113_728996_FFF92D50)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 14:51 +0200, Eric Dumazet wrote:
> So its using a RAW socket ?

Yes:

socket(PF_PACKET, SOCK_RAW, htons(ETH_P_EAPOL))

johannes

> On Thu, Sep 20, 2012 at 2:50 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-09-20 at 14:48 +0200, Eric Dumazet wrote:
> >> Or its a buggy protocol ?
> >>
> >> IP/UDP/TCP definitely works, but maybe another protocol assumes its
> >> header is in skb->head
> >
> > It could be, I think it failed either on EAPOL (which is just userspace
> > registering a protocol socket) or DHCP (same?)
> >
> > johannes
> >
> 


