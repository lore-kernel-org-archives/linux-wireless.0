Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZBTTpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:45:35 -0500
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0902192017n5ae6b23dg36e7aca54cbd703f@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <20090126114453.GB3197@sortiz.org>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com>
	 <20090128121237.GB3197@sortiz.org>
	 <c4d76b3b0902192017n5ae6b23dg36e7aca54cbd703f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 11:49:57 -0800
Message-Id: <1235159397.5860.81.camel@rc-desk> (sfid-20090220_204538_473764_2B82D313)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-19 at 20:17 -0800, Jason Andryuk wrote:
> On Wed, Jan 28, 2009 at 7:12 AM, Samuel Ortiz <samuel@sortiz.org> wrote:
> > On Wed, Jan 28, 2009 at 01:52:17PM +0200, Tomas Winkler wrote:
> >> On Wed, Jan 28, 2009 at 1:37 PM, Samuel Ortiz <samuel@sortiz.org> wrote:
> >> > On Wed, Jan 28, 2009 at 09:12:48AM +0200, Tomas Winkler wrote:
> >> >> On Wed, Jan 28, 2009 at 1:31 AM, Jason Andryuk <jandryuk@gmail.com> wrote:
> >> >> >> No, that's just a consequence of the bug, not the bug itself.
> >> >> >> Would you mind applying this patch on top of your latest wireless-testing tree
> >> >> >> and testing 3945 with it ? Thanks for your patience.
> >> >> >
> >> >> > The patch did not cleanly apply, but I just removed the lines
> >> >> > indicated in the patch.  It crashed with a NULL pointer dereference.
> >> >>
> >> >> Samuel
> >> >> It was really wrong try, you cannot just leave place where firmware
> >> >> updated read pointer unallocated. I would rather focus on differences
> >> >> introduced by this patch.
> >> > Well, that's what I did. I neglected to check if rb_stts were actually used.
> >> >
> >> >
> >> >> commit 738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue
> >> >> management infrastructure from iwlcore is the first to trigger the
> >> >> BUG_ON. However, prior versions would dereference a NULL pointer
> >> >> before the driver could get far enough to trigger the BUG_ON.
> >> > I know, that's what Jason described.
> >> > I think I now understand why. Prior to
> >> > 738910c064ff461051cd37e17199f270ff88a9a3, you introduced
> >> > c2a0aa3cb733452e749727680e380dca6cc10a68 without actually allocating the
> >> > rb_stts pointer, which was really wrong too.
> >>
> >> Yes I made mistake then I tought that 3945 take also init path of agn
> >> already... Now it's hard to besect :(.
> >> I suspect the rx queue managment infrastructure more because we brohgt
> >> iwlagn bug into 3945 I guess it wrong rx buffer index handling. It's
> >> really important we nail it now this will solve also our troubles in
> >> iwlagn, where it get lost upon tons of patches.
> > I agree. I also suspect that a lot more people will report the same problem
> > when this code leaves wireless-testing for upstream inclusion.
> 
> I tried out wireless-testing as of 2009-02-18.  I was excited
> initially because I was able to connect to my AP and ping and access
> the internet.  I started writing an email over the connection, but
> then things went sour.
> 
> Logs showed a Microcode SW error, but that comes after successful
> authentication to the AP.
> 
> [  323.904100] iwl3945 0000:03:00.0: Microcode SW error detected.
> Restarting 0x82000008.
> [  323.904119] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd
> UNKNOWN (0x00) seq 0x013A ser 0x004E0000
> 
> I think it was still working, but it then stopped and I discovered a
> second Microcode SW error.
> 
> [  713.561161] iwl3945 0000:03:00.0: Microcode SW error detected.
> Restarting 0x82000008.
> [  713.561172] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd
> UNKNOWN (0x40) seq 0x013A ser 0x004E0000
> 
> Debugging was not turned on, so I don't have further information.
> 
> When I rebooted, iwl3945 failed to find the AP and hence did not connect.
> 

Running with full debugging on all the time will not be practical - but
there is a debug flag that will only be used when encountering a
firmware error. This flag will cause a dump of event information that
will help with debugging. Would it be possible to run your driver with
debug=0x40000 all the time? 

Reinette


