Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39619 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1F2Bbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 21:31:39 -0400
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
	rdunlap@xenotime.net
Date: Tue, 28 Jun 2011 18:31:28 -0700
In-Reply-To: <1309292325.29598.9.camel@Joe-Laptop>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
	 <1309292325.29598.9.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1309311096.2208.33.camel@aeonflux> (sfid-20110629_033142_039273_F38AEE39)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

> > The NFC subsystem core is responsible for providing the device driver
> > interface. It is also responsible for providing an interface to the control
> > operations and data exchange.
> []
> > diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
> []
> > +#define NFC_INFO(fmt, arg...) printk(KERN_INFO "NFC: " fmt "\n", ## arg)
> > +#define NFC_ERR(fmt, arg...) printk(KERN_ERR "%s: " fmt "\n", __func__, ## arg)
> > +#define NFC_DBG(fmt, arg...) pr_debug("%s: " fmt "\n", __func__, ## arg)
> 
> I think these #defines and their uses would be
> better lower case.
> 
> #define nfc_info(etc...)
> #define nfc_err(etc...)
> #define nfc_dbg(etc...)
> 
> And because these don't really take any nfc specific
> struct as an argument, may be better removed altogether
> and replaced with the pr_<level> equivalents.

it is similar to what we do in the Bluetooth subsystem, but in the end
upper-case vs lower-case is a bit more personal taste.

The pr_<level> ones are nice and I wished we had them all back in the
days, but the NFC ones actually could take the controller as argument
and then us the dev_* versions of these commands.

At this stage of the project it is a bit too early to tell I guess.

> I think emitting __func__ rarely adds useful information.

Depends on how you are using your debug statements. I find it really
helpful since then you can keep the text detail to a minimum.

Regards

Marcel


