Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38893 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab1F2SBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 14:01:00 -0400
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
	rdunlap@xenotime.net
Date: Wed, 29 Jun 2011 11:00:50 -0700
In-Reply-To: <1309312164.29598.53.camel@Joe-Laptop>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
	 <1309292325.29598.9.camel@Joe-Laptop>  <1309311096.2208.33.camel@aeonflux>
	 <1309312164.29598.53.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1309370457.2208.48.camel@aeonflux> (sfid-20110629_200104_383047_664CF6C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

> > The pr_<level> ones are nice and I wished we had them all back in the
> > days, but the NFC ones actually could take the controller as argument
> > and then us the dev_* versions of these commands.
> 
> I do think that if there's a controller struct that's always
> or mostly used with nfc_<level>, then it should be added and
> passed to the functions arguments, maybe with NULL used where
> necessary.
> 
> > At this stage of the project it is a bit too early to tell I guess.
> > > I think emitting __func__ rarely adds useful information.
> > Depends on how you are using your debug statements. I find it really
> > helpful since then you can keep the text detail to a minimum.
> 
> I don't disagree that while debugging function names
> and tracing function entries/exits are useful.
> 
> Today, dynamic_debug can add __func__ to the output as
> desired so I think that it's not really necessary
> to add to any <foo>_dbg callsite.

I did not know that. Then we might should go ahead and also cleanup the
Bluetooth subsystem.

We do use an implied "Bluetooth: " prefix when calling BT_INFO, but that
can be easily changed to bt_info() as well since I do not care about
that part. 

The Bluetooth subsystem has a Linux 2.4 legacy history and a lot of
things can be done a lot nicer these days.

Regards

Marcel


