Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0DWF5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 01:57:25 -0400
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <u2j6ed0b2681004221347z78c15832z3e0ff3ea51b4a5a8@mail.gmail.com>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
	 <g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
	 <1271954537.8469.15.camel@mj>
	 <x2l43e72e891004221333he942ee92u3ef4c6994d769694@mail.gmail.com>
	 <u2j6ed0b2681004221347z78c15832z3e0ff3ea51b4a5a8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 07:57:21 +0200
Message-ID: <1272002241.3737.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-22 at 23:47 +0300, Grazvydas Ignotas wrote:
> On Thu, Apr 22, 2010 at 11:33 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Thu, Apr 22, 2010 at 9:42 AM, Pavel Roskin <proski@gnu.org> wrote:
> >> On Thu, 2010-04-22 at 09:33 -0700, Luis R. Rodriguez wrote:
> >>
> >>> How was this compiling for older kernels before then?
> >>
> >> Compiling was fine, but loading the firmware was failing sometimes.  I'm
> >> glad somebody figured it out.  Thank you, Grazvydas!
> >
> > OK Applied. I'm still puzzled, if it compiled, then that means
> > dev_set_uevent_suppress() was being defined somehow for older kernels.
> 
> there was already ifdef, old code:
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>        dev_set_uevent_suppress(f_dev, 1);
>  #endif
> 
> new code:
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>        dev_set_uevent_suppress(f_dev, 1);
> #else
>        f_dev->uevent_suppress = 1;
>  #endif

And the argument is that the new code should be

	dev_set_uevent_suppress(f_dev, 1);

and some header file should provide

static inline void dev_set_uevent_suppress(...)
{
	f_dev->uevent_suppress = 1;
}

which makes perfect sense. Although Luis merged it, a fix would be
useful.

Luis, a patch changing firmware_class.c just entered the tree :P I made
it.

johannes

