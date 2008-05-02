Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14261 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYEBGKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 02:10:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] libertas: reduce command retry time
Date: Fri, 2 May 2008 08:07:44 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200804301644.29927.hs4233@mail.mn-solutions.de> <200805012330.57750.hs4233@mail.mn-solutions.de> <1209679021.25560.594.camel@pmac.infradead.org>
In-Reply-To: <1209679021.25560.594.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805020807.44472.hs4233@mail.mn-solutions.de> (sfid-20080502_081022_012587_9CFAFB36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Or: maybe there is another way to make "pccardctl eject"
> > work reasonably fast in the case of a retrying command. Any
> > idea?
>
> Does it set priv->surpriseremoved? We should honour that.

Unfortunately not. Manually ejecting the card sets this (via 
ISR). Then the driver very quickly disables the card, retrying 
commands or not. It's just "pccardctl eject" that can, under 
circumstances, take ages. Unfortunately this circumstances 
happen in my (embedded) hardware setup, e.g. when 
suspending/resuming.

At resume time, I simply do "pccardctl eject" / "pccardctl 
insert" to get the driver correctly initialized again and 
associating. Because doing "real" suspend/resume is currently 
impossible for me with my knowledge of the firmware.


> No, it just waits until the timer has been properly removed.
> If the timer was set for some time in the future, it doesn't
> wait for it to happen naturally.

Oh, this is what I thought would happen. In this case, it 
{c/sh}ould stay at del_timer_sync().
