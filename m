Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51986 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0HSBJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 21:09:13 -0400
Received: by gxk23 with SMTP id 23so459608gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Aug 2010 18:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008190001.11342.rjw@sisk.pl>
References: <201008190001.11342.rjw@sisk.pl>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 18 Aug 2010 18:00:47 -0700
Message-ID: <AANLkTi=S3JE=1J9xQtBAN5hHTqGSfohi4vL82iZHMWp+@mail.gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 3:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> While testing 2.6.36-rc1 (with a couple of fixes on top)

Which couple of fixes?

> I noticed that the ath9k
> driver didn't work after resume from suspend to RAM.

To rule out if its an ath9k issue you can try
compat-wireless-2.6.36-rc1 from here:

http://wireless.kernel.org/en/users/Download/stable/

and install it on an older kernel, you can use ./scripts/driver-select
to only enable ath9k to compile.

I've been using pm-suspend on this release for a few days now without
any issue but I am using an AR9003 chipset. What chipset are you
using? Can you provide the dmesg output upon module load?

>  An attempt to unload the
> driver using rmmod caused the BUG_ON() in kernel/workqueue.c:2844 to trigger.

That's a bug, a regression likely.

> I wonder if that regression is a result of the recent workqueue changes?

Yeah very likely.

  Luis
