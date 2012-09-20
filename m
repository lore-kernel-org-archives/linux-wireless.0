Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab2ITPEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 11:04:47 -0400
Message-ID: <1348153522.4161.37.camel@jlt4.sipsolutions.net> (sfid-20120920_170456_258449_3D51D76F)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: artem.bityutskiy@linux.intel.com,
	Eric Dumazet <edumazet@google.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 17:05:22 +0200
In-Reply-To: <1348152971.31352.140.camel@edumazet-glaptop> (sfid-20120920_165616_301862_3EBAF30C)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348151149.31352.109.camel@edumazet-glaptop>
	 <1348151876.2388.24.camel@sauron.fi.intel.com>
	 <1348152971.31352.140.camel@edumazet-glaptop>
	 (sfid-20120920_165616_301862_3EBAF30C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 16:56 +0200, Eric Dumazet wrote:
> On Thu, 2012-09-20 at 17:37 +0300, Artem Bityutskiy wrote:
> > On Thu, 2012-09-20 at 16:25 +0200, Eric Dumazet wrote:
> > > Please remove this hack and try the following bugfix in raw handler
> > > 
> > > icmp_filter() should not modify skb, or else its caller should not
> > > assume ip_hdr() is unchanged.
> > 
> > Did not help :(
> > 
> 
> What gives (after some failures)
> 
> cat /proc/net/raw

Note I think the failing packets are dhcp packets, and connman seems to
use an AF_INET, SOCK_DGRAM, IPPROTO_UDP socket for those, and binds it
to the right device. I'd be quite surprised though if UDP code had
issues with paged Rx??

johannes

