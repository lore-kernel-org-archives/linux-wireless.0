Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3305 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1F2Bt0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 21:49:26 -0400
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
	rdunlap@xenotime.net
In-Reply-To: <1309311096.2208.33.camel@aeonflux>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
	 <1309292325.29598.9.camel@Joe-Laptop>  <1309311096.2208.33.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 18:49:24 -0700
Message-ID: <1309312164.29598.53.camel@Joe-Laptop> (sfid-20110629_034929_452032_99C856E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-28 at 18:31 -0700, Marcel Holtmann wrote:
> Hi Joe,

Hello Marcel.

> > > The NFC subsystem core is responsible for providing the device driver
> > > interface. It is also responsible for providing an interface to the control
> > > operations and data exchange.
> > []
> > > diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
> > []
> > > +#define NFC_INFO(fmt, arg...) printk(KERN_INFO "NFC: " fmt "\n", ## arg)
> > > +#define NFC_ERR(fmt, arg...) printk(KERN_ERR "%s: " fmt "\n", __func__, ## arg)
> > > +#define NFC_DBG(fmt, arg...) pr_debug("%s: " fmt "\n", __func__, ## arg)
> > I think these #defines and their uses would be
> > better lower case.
> > #define nfc_info(etc...)
> > #define nfc_err(etc...)
> > #define nfc_dbg(etc...)
> > And because these don't really take any nfc specific
> > struct as an argument, may be better removed altogether
> > and replaced with the pr_<level> equivalents.
> 
> it is similar to what we do in the Bluetooth subsystem, but in the end
> upper-case vs lower-case is a bit more personal taste.

And a bit of of coding style agreement too.

> The pr_<level> ones are nice and I wished we had them all back in the
> days, but the NFC ones actually could take the controller as argument
> and then us the dev_* versions of these commands.

I do think that if there's a controller struct that's always
or mostly used with nfc_<level>, then it should be added and
passed to the functions arguments, maybe with NULL used where
necessary.

> At this stage of the project it is a bit too early to tell I guess.
> > I think emitting __func__ rarely adds useful information.
> Depends on how you are using your debug statements. I find it really
> helpful since then you can keep the text detail to a minimum.

I don't disagree that while debugging function names
and tracing function entries/exits are useful.

Today, dynamic_debug can add __func__ to the output as
desired so I think that it's not really necessary
to add to any <foo>_dbg callsite.

I don't think they're ever useful on <foo>_err.
If they are, then the message probably isn't
descriptive enough and adding %s/__func__ as
necessary is OK.

cheers, Joe


