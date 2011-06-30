Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46766 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1F3D0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 23:26:24 -0400
Received: by iwn6 with SMTP id 6so1563332iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 20:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309391163.29598.92.camel@Joe-Laptop>
References: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org>
 <1309285246-8495-2-git-send-email-aloisio.almeida@openbossa.org>
 <1309292325.29598.9.camel@Joe-Laptop> <1309311096.2208.33.camel@aeonflux>
 <1309312164.29598.53.camel@Joe-Laptop> <1309370457.2208.48.camel@aeonflux>
 <BANLkTinospg_dhTC8Tcok3kqk9gOryG6eA@mail.gmail.com> <1309391163.29598.92.camel@Joe-Laptop>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Thu, 30 Jun 2011 00:26:03 -0300
Message-ID: <CAEsZsEgfKPtsXKGiAV3QuH=YESyS+GHnsNjauVZV==AN94fxug@mail.gmail.com> (sfid-20110630_052636_988126_B6A70721)
Subject: Re: [PATCH v4 1/6] NFC: add nfc subsystem core
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Wed, Jun 29, 2011 at 8:46 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-06-29 at 20:23 -0300, Aloisio Almeida wrote:
>> >> Today, dynamic_debug can add __func__ to the output as
>> >> desired so I think that it's not really necessary
>> >> to add to any <foo>_dbg callsite.
>> That's true only for pr_debug() function. You cannot add __func__ info
>> on dev_dbg() calls dynamically.
>
> I believe that's false.  It's definitely stored.
>
> #define dynamic_dev_dbg(dev, fmt, ...) do {                             \
>        static struct _ddebug descriptor                                \
>        __used                                                          \
>        __attribute__((section("__verbose"), aligned(8))) =             \
>        { KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,            \
>                _DPRINTK_FLAGS_DEFAULT };                               \
>        if (unlikely(descriptor.enabled))                               \
>                dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);        \
>        } while (0)
>
> Jason?  True or false?

It's stored but not retrieved. If you check lib/dynamic_debug.c you
see that only __dynamic_pr_debug() (called by dynamic_pr_debug() )
adds such information on prints. The dev_printk() does not check
_DPRINTK_FLAGS_INCL_* flags.

> I think you should add NFC to nfc_dev_err too.

That's make sense to me also.

Aloisio
