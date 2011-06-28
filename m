Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3292 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1F1XwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 19:52:04 -0400
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
From: Joe Perches <joe@perches.com>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
	rdunlap@xenotime.net
In-Reply-To: <BANLkTikQNMUkS4N7UfCYTAN9TZQzj8pwwQ@mail.gmail.com>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
	 <1309292325.29598.9.camel@Joe-Laptop>
	 <BANLkTikQNMUkS4N7UfCYTAN9TZQzj8pwwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 16:52:02 -0700
Message-ID: <1309305122.29598.43.camel@Joe-Laptop> (sfid-20110629_015209_359560_7DD9DF6C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-28 at 20:31 -0300, Aloisio Almeida wrote:
> Hi Joe,

Oi Aloisio.

> On Tue, Jun 28, 2011 at 5:18 PM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2011-06-28 at 15:20 -0300, Aloisio Almeida Jr wrote:
> >> From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> >> The NFC subsystem core is responsible for providing the device driver
> >> interface. It is also responsible for providing an interface to the control
> >> operations and data exchange.
> > []
> >> diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
> > []
> >> +#define NFC_INFO(fmt, arg...) printk(KERN_INFO "NFC: " fmt "\n", ## arg)
> >> +#define NFC_ERR(fmt, arg...) printk(KERN_ERR "%s: " fmt "\n", __func__, ## arg)
> >> +#define NFC_DBG(fmt, arg...) pr_debug("%s: " fmt "\n", __func__, ## arg)
> >
> > I think these #defines and their uses would be
> > better lower case.
> >
> > #define nfc_info(etc...)
> > #define nfc_err(etc...)
> > #define nfc_dbg(etc...)
> >
> > And because these don't really take any nfc specific
> > struct as an argument, may be better removed altogether
> > and replaced with the pr_<level> equivalents.
> I was using pr_*() on previous versions. One of the proposed changes
> for v4 was to create these macros to avoid calling pr_*() functions
> with same parameters every time. The implementation chosen is based on
> BT_* macros from bluetooth subsystem.
> > I think emitting __func__ rarely adds useful information.
> I can say that during the implementation phase I considered __func__
> useful, mainly for tracing the execution. That's the reason I left it
> in the code.

Up to you, but regardless, I think the bluetooth macros
aren't good ones to follow.  Most all of the other
<foo>_<level> output logging forms are lowercase.

cheers, Joe

