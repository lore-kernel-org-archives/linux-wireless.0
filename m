Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3327 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1F2XqG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:46:06 -0400
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
From: Joe Perches <joe@perches.com>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>,
	Jason Baron <jbaron@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net
In-Reply-To: <BANLkTinospg_dhTC8Tcok3kqk9gOryG6eA@mail.gmail.com>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
	 <1309292325.29598.9.camel@Joe-Laptop> <1309311096.2208.33.camel@aeonflux>
	 <1309312164.29598.53.camel@Joe-Laptop> <1309370457.2208.48.camel@aeonflux>
	 <BANLkTinospg_dhTC8Tcok3kqk9gOryG6eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 16:46:03 -0700
Message-ID: <1309391163.29598.92.camel@Joe-Laptop> (sfid-20110630_014611_582007_166DCF09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-29 at 20:23 -0300, Aloisio Almeida wrote:
> >> Today, dynamic_debug can add __func__ to the output as
> >> desired so I think that it's not really necessary
> >> to add to any <foo>_dbg callsite.
> That's true only for pr_debug() function. You cannot add __func__ info
> on dev_dbg() calls dynamically.

I believe that's false.  It's definitely stored.

#define dynamic_dev_dbg(dev, fmt, ...) do {				\
	static struct _ddebug descriptor				\
	__used								\
	__attribute__((section("__verbose"), aligned(8))) =		\
	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
		_DPRINTK_FLAGS_DEFAULT };				\
	if (unlikely(descriptor.enabled))				\
		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
	} while (0)

Jason?  True or false?

> So, for net/nfc/* I propose to use directly pr_*() functions.
> For device drivers the following macros would be provided:
> #define nfc_dev_info(dev, fmt, arg...) dev_info((dev), "NFC: " fmt, ## arg)
> #define nfc_dev_err(dev, fmt, arg...) dev_err((dev), "%s: " fmt,
> __func__, ## arg)
> #define nfc_dev_dbg(dev, fmt, arg...) dev_dbg((dev), "%s: " fmt,
> __func__, ## arg)
> What do you think?

I still think __func__ isn't useful ;)
I think you should add NFC to nfc_dev_err too.

cheers, Joe

