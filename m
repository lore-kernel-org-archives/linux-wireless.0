Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 39.mail-out.ovh.net ([213.251.138.60]:57229 "HELO
	39.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751304AbZA1MKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 07:10:11 -0500
Date: Wed, 28 Jan 2009 13:12:37 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
Message-ID: <20090128121237.GB3197@sortiz.org> (sfid-20090128_131017_774697_FD013214)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com> <20090126114453.GB3197@sortiz.org> <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com> <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com> <20090127162437.GA3596@sortiz.org> <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com> <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com> <20090128113751.GA3197@sortiz.org> <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 01:52:17PM +0200, Tomas Winkler wrote:
> On Wed, Jan 28, 2009 at 1:37 PM, Samuel Ortiz <samuel@sortiz.org> wrote:
> > On Wed, Jan 28, 2009 at 09:12:48AM +0200, Tomas Winkler wrote:
> >> On Wed, Jan 28, 2009 at 1:31 AM, Jason Andryuk <jandryuk@gmail.com> wrote:
> >> >> No, that's just a consequence of the bug, not the bug itself.
> >> >> Would you mind applying this patch on top of your latest wireless-testing tree
> >> >> and testing 3945 with it ? Thanks for your patience.
> >> >
> >> > The patch did not cleanly apply, but I just removed the lines
> >> > indicated in the patch.  It crashed with a NULL pointer dereference.
> >>
> >> Samuel
> >> It was really wrong try, you cannot just leave place where firmware
> >> updated read pointer unallocated. I would rather focus on differences
> >> introduced by this patch.
> > Well, that's what I did. I neglected to check if rb_stts were actually used.
> >
> >
> >> commit 738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue
> >> management infrastructure from iwlcore is the first to trigger the
> >> BUG_ON. However, prior versions would dereference a NULL pointer
> >> before the driver could get far enough to trigger the BUG_ON.
> > I know, that's what Jason described.
> > I think I now understand why. Prior to
> > 738910c064ff461051cd37e17199f270ff88a9a3, you introduced
> > c2a0aa3cb733452e749727680e380dca6cc10a68 without actually allocating the
> > rb_stts pointer, which was really wrong too.
> 
> Yes I made mistake then I tought that 3945 take also init path of agn
> already... Now it's hard to besect :(.
> I suspect the rx queue managment infrastructure more because we brohgt
> iwlagn bug into 3945 I guess it wrong rx buffer index handling. It's
> really important we nail it now this will solve also our troubles in
> iwlagn, where it get lost upon tons of patches.
I agree. I also suspect that a lot more people will report the same problem
when this code leaves wireless-testing for upstream inclusion.

Cheers,
Samuel.
 
> Thanks
> Tomas

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
