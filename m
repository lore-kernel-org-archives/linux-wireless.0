Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:59973 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244AbZKDWpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:45:45 -0500
Received: by iwn10 with SMTP id 10so5344354iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 14:45:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40f31dec0911041431i6f718bf1x1e52d9e12ab22060@mail.gmail.com>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com>
	<40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com>
	<43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com>
	<43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com>
	<43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com>
	<43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com>
	<20091104220034.GI10555@parisc-linux.org> <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com>
	<20091104221426.GA2599@bombadil.infradead.org> <40f31dec0911041431i6f718bf1x1e52d9e12ab22060@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 14:45:30 -0800
Message-ID: <43e72e890911041445s4e69aa46nda01d423c1bd8f7d@mail.gmail.com>
Subject: Re: pci_set_mwi() and ath5k
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 2:31 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2009/11/5 Luis R. Rodriguez <mcgrof@bombadil.infradead.org>:
>> On Wed, Nov 04, 2009 at 02:04:11PM -0800, Luis R. Rodriguez wrote:
>>> On Wed, Nov 4, 2009 at 2:00 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>>> > On Wed, Nov 04, 2009 at 01:52:30PM -0800, Luis R. Rodriguez wrote:
>>> >> > Even better: I just confirmation from our systems team that our legacy
>>> >> > devices and 11n PCI devices don't support MWR so I'll remove all that
>>> >> > cruft crap.
>>> >>
>>> >> I meant MWI of course.
>>> >
>>> > Yes, but they don't necessarily just use cacheline size for MWI ... some
>>> > devices use cacheline size for setting up data structures.  Might be
>>> > worth just checking explicitly that they don't use the cacheline size
>>> > register for anything.
>>>
>>> Oh right -- so the typical Atheros hack for this is to check the cache
>>> line size, and if its 0 set it to L1_CACHE_BYTES. Then eventually read
>>> from PCI_CACHE_LINE_SIZE pci config to align the skb data. So what I
>>> was doing now is removing all this cruft and replacing it with a
>>> generic allocator for atheros drivers that aligns simply to the
>>> L1_CACHE_BYTES. Sound kosher?
>>
>> Something like this:
>>
>
> According to comments inside MadWiFi AR5210 needs cache line align
> else we get corruptions.

For what though?

> I don't know if this is correct for all
> platforms or later cards but since we (plan to) support AR5210 i guess
> we should leave it there. We need to test this a lot on various
> archs/cards before applying it.

There are two cases where we can use the PCI_CACHE_LINE_SIZE:

1) Hardware has been designed to use it on some block to align some data somehow
2) Software uses it to align skb->data for performance/hw purposes

I believe the second case can be handled by using L1_CACHE_BYTES
instead and I'd at least like to change our common skb allocator to
use that.

The first case is where it seems there may be some skepticism as to
whether or not hw really did not rely on it and I agree its safer to
keep the programming of the  PCI_CACHE_LINE_SIZE in case it has a
bogus value.

Does this seem reasonable?

  Luis
