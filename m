Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58514 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaC2TtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2014 15:49:11 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so4502333wgh.34
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2014 12:49:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140329.153737.671362434625537776.davem@davemloft.net>
References: <CAG-2HqVQ-MAZgsZAkykvVtbtYgDA3bfJA5rEqpdX5vBqPTjLJg@mail.gmail.com>
 <20140328.214254.1620280677250220442.davem@davemloft.net> <CAG-2HqWQsLPaaHxMFn5Bha0BGKSAVZV9n87KTCsbQ1ewktzZvA@mail.gmail.com>
 <20140329.153737.671362434625537776.davem@davemloft.net>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 29 Mar 2014 20:48:47 +0100
Message-ID: <CAPXgP11ce5zXePU=idVqXRREpXpNTa4HBcvyq_hh1pdiVJme8Q@mail.gmail.com> (sfid-20140329_205001_163167_1361040C)
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
To: David Miller <davem@davemloft.net>
Cc: Tom Gundersen <teg@jklm.no>,
	David Herrmann <dh.herrmann@gmail.com>, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 29, 2014 at 8:37 PM, David Miller <davem@davemloft.net> wrote:
> From: Tom Gundersen <teg@jklm.no>
> Date: Sat, 29 Mar 2014 10:46:02 +0100
>
>> The issue I see with that is that there are several ways to generate
>> predictable names, and the user may want to chose between them, so
>> this is arguably policy that should not be in the kernel. If you don't
>> think that's a problem, I'd be happy to submit a patch to move all
>> this logic from udev to the kernel, just let me know how you see it.
>
> Unfortunately, we have already allowed this kind of thing for setting
> MAC addresses so I guess I'll have to allow your changes to be applied.
>
> But before I ask you to resubmit, do you have full buy-in from the
> udev folks for this facility?

Absolutely, it is very useful to have.

Today, there is no way for userland to distinguish explicitly
requested and predictable names provided by tools, from unpredictable
names composed by the kernel itself by adding an unpredictable
enumeration number.

It allows us the work around the common problems in general purpose
Linux, where we have no strong dependencies, not necessarily central
management, and loose coupling between components.

This information will allow us to apply best-effort or common sense to
the default udev device name policies, like:
  - leave the name alone if someone has asked explicitly for that name
  - leave the name alone if someone else has already renamed it after
its first creation

So, having that information in /sys would be very welcome from udev's
point of view.

Thanks,
Kay
