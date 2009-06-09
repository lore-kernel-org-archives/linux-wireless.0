Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:28989 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZFIBuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 21:50:54 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2297697qwd.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 18:50:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244510236.28215.32.camel@mj>
References: <1244501988.25158.57.camel@mj> <20090608231919.GC23972@bombadil.infradead.org>
	<1244510236.28215.32.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Jun 2009 18:50:36 -0700
Message-ID: <43e72e890906081850q641f8c0m211d531544f499f9@mail.gmail.com>
Subject: Re: BUG at net/wireless/reg.c:2132 on PowerPC
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2009 at 6:17 PM, Pavel Roskin<proski@gnu.org> wrote:
> On Mon, 2009-06-08 at 19:19 -0400, Luis R. Rodriguez wrote:
>
>> Thank you for reporting this, try loading the system without ath5k present
>> (mv ath5k.ko ath5k.ignore is an easy way) then prior to loadin git in a window
>> get 'iw event' running.
>
> I'm sorry, but I managed to "fix" the problem without having a way to
> recreate it again.  I emptied /etc/udev/rules.d/70-persistent-net.rules
> and removed /etc/sysconfig/network-scripts/ifcfg-wlan0, and the problem
> is gone, but I didn't preserve the original files, and I cannot make the
> crash happen again.
>
> Also, it turns out that pciutils failed to upgrade to the Fedora 11
> version, and "lspci -v" was crashing.  After upgrading pciutils the BUG
> was gone, but downgrading it didn't make it reappear :-(
>
> I tried what you said, and that's what I get:
>
> # iw event
> phy #0: regulatory domain change: set to US by a driver request on phy0
> phy #1: regulatory domain change: set to US by a driver request on phy1
>
>>
>> -             BUG_ON(request_wiphy->regd);
>> +             /*
>> +              * Userspace could have sent two replies with only
>> +              * one kernel request.
>> +              */
>> +             if (request_wiphy->regd)
>> +                     return -EALREADY;
>
> I think it's a good idea.  Stupid userspace shouldn't cause kernel bugs.

Agreed.

  Luis
