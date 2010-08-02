Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49725 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0HBUmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:42:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 13:42:16 -0700
Date: Mon, 2 Aug 2010 13:42:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joe Perches <joe@perches.com>
CC: Kshitij Kulshreshtha <kkhere.geo@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in
 v2.6.36
Message-ID: <20100802204211.GE8920@tux>
References: <4C55D22A.5040302@hauke-m.de>
 <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
 <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
 <4C571F0B.3000200@gmail.com>
 <1280778534.1752.68.camel@Joe-Laptop.home>
 <4C57227A.1050802@gmail.com>
 <1280779727.1752.71.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1280779727.1752.71.camel@Joe-Laptop.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 02, 2010 at 01:08:47PM -0700, Joe Perches wrote:
> On Mon, 2010-08-02 at 21:54 +0200, Kshitij Kulshreshtha wrote:
> > As on 2010-08-02 21:48, Joe Perches did write:
> > > On Mon, 2010-08-02 at 21:39 +0200, Kshitij Kulshreshtha wrote:
> > >> As on 2010-08-02 20:00, Luis R. Rodriguez did write:
> > >>> On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
> > >>>> +struct va_format {
> > >>>> +       const char *fmt;
> > >>>> +       va_list *va;
> > >>>> +};
> > >>> I'll apply this for now but what caller uses this for example?
> > > Why is this necessary?
> > I needed this to compile compat-wireless which is based on linux-next.
> > Otherwise net/wireless/core.c fails to compile, due to the use of this
> > struct va_format in the functions defined in lines 910--958. If this
> > usage is reverted, we won't need it in compat.
> 
> I see your problem.
> 
> I think your problem should not be a constraint
> on new development and I do not think the new use
> should be reverted.

Joe, compat.git does not go upstream into the kernel, compat.git
tries to backport as much new kernel stuff for usage on older kernels.
compat-wireless uses compat.git to help with backporting the 802.11/BT/ethernet
subsystems to older kernels.

In this case the patch Kshitij sent for compat.git is OK since the struct is
used in code only by cfg80211 which we end up updating using compat-wireless.

Thanks for the clarifications Kshitij.

  Luis
