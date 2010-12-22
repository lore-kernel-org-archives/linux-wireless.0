Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49364 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0LVRpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 12:45:09 -0500
Date: Wed, 22 Dec 2010 12:32:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Elvis Dowson <elvis.dowson@mac.com>,
	"Kahn, Gery" <geryk@ti.com>, Oz Krakowski <ozk@ti.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
Message-ID: <20101222173227.GB10046@tuxdriver.com>
References: <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de>
 <AANLkTimRrX1HCmz2EnsA-4=ZBLUJ-86O-bpGgjEw4Lbw@mail.gmail.com>
 <AANLkTi=dz1eS9fdyQiZ_P41sL77HQJzCuMVKgW36JcTx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=dz1eS9fdyQiZ_P41sL77HQJzCuMVKgW36JcTx@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 12:22:21PM -0500, Luis R. Rodriguez wrote:
> On Wed, Dec 22, 2010 at 12:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Wed, Dec 22, 2010 at 11:47 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >> On 12/22/2010 05:13 PM, Luis R. Rodriguez wrote:
> >>> On Wed, Dec 22, 2010 at 11:09 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> >>>> netdev_alloc_skb_ip_align
> >>>
> >>> I notice you have an android kernel, is that kernel a vanilla kernel
> >>> or did it get netdev_alloc_skb_ip_align() cherry picked into it?
> >>>
> >>>   Luis
> >>
> >> netdev_alloc_skb_ip_align is not defined in the 2.6.32.27 vanilla
> >> kernel. Someone else (google or ti) must have backported it to this
> >> kernel and added it to your kernel.
> >>
> >> I do not want to add some special handling into compat-wireless just for
> >> some android kernel. Just remove netdev_alloc_skb_ip_align() and
> >> NETDEV_POST_INIT from include/linux/compat-2.6.33.h and the compile
> >> problems you posted should be fixed.
> >
> > Well we did something to accommodate RHEL, I wouldn't mind supporting
> > some fudge for Android so long as someone is willing to submit the
> > patch and identify the kernel properly. Android is popular enough and
> > I rather reduce the time it takes to use it there than to create an
> > extra hurdle.
> 
> Now that I think about it I don't think John ever respinned his
> patches for compat-wireless for RHEL.

No, I didn't.  Johannes wanted some sort of API level indicator instead
of checking for RHEL kernels, but I have no idea how to implement that.

FWIW, I'd rather you just take the patches I submitted and any
similar patches for other Enterprise-y distros (including Android).
But if someone else can demonstrate a workable, better alternative
then I will try to comply.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
