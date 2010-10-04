Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0JDScE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:32:04 -0400
Subject: Re: wireless-testing (2.6.36-rc6):  inconsistent {IN-SOFTIRQ-W} ->
 {SOFTIRQ-ON-W} usage.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4CAA158F.10108@candelatech.com>
References: <4CA4F000.2060509@candelatech.com>
	 <1285933789.3739.34.camel@jlt3.sipsolutions.net>
	 <4CAA158F.10108@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:31:55 +0200
Message-ID: <1286217115.3620.46.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 10:57 -0700, Ben Greear wrote:

> >> =================================
> >> [ INFO: inconsistent lock state ]
> >> 2.6.36-rc6-wl+ #20
> >> ---------------------------------
> >> inconsistent {IN-SOFTIRQ-W} ->  {SOFTIRQ-ON-W} usage.
> >> kworker/u:0/5 [HC0[0]:SC0[0]:HE1:SE1] takes:
> >>    (&(&list->lock)->rlock){+.?...}, at: [<c0741066>] packet_rcv+0x1f3/0x27a
> >
> > I think this is due to
> >
> > commit 5ed3bc7288487bd4f891f420a07319e0b538b4fe
> > Author: John W. Linville<linville@tuxdriver.com>
> > Date:   Thu Jun 24 14:38:30 2010 -0400
> >
> >      mac80211: use netif_receive_skb in ieee80211_tx_status callpath
> 
> Before I go hacking on this, is anyone already working on it?

I'm not aware of anyone.

johannes

