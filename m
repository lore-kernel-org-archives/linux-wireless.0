Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48814 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZJZHyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 03:54:39 -0400
Date: Mon, 26 Oct 2009 07:54:38 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tilman Schmidt <tilman@imap.cc>,
	David Miller <davem@davemloft.net>, hidave.darkstar@gmail.com,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-wireless@vger.kernel.org, linux-ppp@vger.kernel.org,
	netdev@vger.kernel.org, paulus@samba.org,
	Michael Buesch <mb@bu3sch.de>,
	Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091026075438.GB6187@ff.dom.local>
References: <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc> <20091021211906.GA11401@ami.dom.local> <1256160330.12174.2.camel@johannes.local> <20091021213947.GA12202@ami.dom.local> <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc> <1256309191.12174.51.camel@johannes.local> <20091026074126.GA6187@ff.dom.local> <1256543054.28230.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1256543054.28230.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 08:44:14AM +0100, Johannes Berg wrote:
> On Mon, 2009-10-26 at 07:41 +0000, Jarek Poplawski wrote:
> 
> > > netif_rx_ni() disables preemption.
> > 
> > You wrote earlier:
> > 
> > > [...] the networking layer needs to have
> > > packets handed to it with softirqs disabled.
> > 
> > How disabling preemption can fix something which needs softirqs
> > disabled? Could you be more precise?
> 
> No, I wrote that I didn't know. I suppose now that I looked at it I do
> know, and only disabling preemption is required.

But netif_rx has preemption disabled most of the time (by hardirqs
disabling). So maybe disabling preemption isn't the main reason here
either?

Jarek P.
