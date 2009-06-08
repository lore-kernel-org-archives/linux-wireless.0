Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42875 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZFHASw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 20:18:52 -0400
Subject: Re: [PATCH] rfkill: print events when input handler is
 disabled/enabled
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244395114.12956.2.camel@johannes.local>
References: <1244370412.2907.2.camel@johannes.local>
	 <1244388331.23850.85.camel@localhost.localdomain>
	 <1244395114.12956.2.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 02:18:24 +0200
Message-Id: <1244420304.23850.112.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > >  	if (!data->input_handler) {
> > > -		atomic_inc(&rfkill_input_disabled);
> > > +		if (atomic_inc_return(&rfkill_input_disabled) == 1)
> > > +			printk(KERN_DEBUG "rfkill: input handler disabled\n");
> > >  		data->input_handler = true;
> > >  	}
> > 
> > do you really think the == 1 is the correct thing here. I think that
> > should be a > 0.
> 
> Why would you want to know every time somebody uses the ioctl? I think
> the first time should be sufficient, no? Common case will hopefully be
> only one program using it anyway though.

you are right, we only care about the printk once. No need to keep
printing it on every change.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regard

Marcel


