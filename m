Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42670 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbZBWTQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 14:16:44 -0500
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1235363865.6190.8.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <1ba2fa240901280352o56ccbc07h50c7a4bfcd0ac9ab@mail.gmail.com>
	 <20090128121237.GB3197@sortiz.org>
	 <c4d76b3b0902192017n5ae6b23dg36e7aca54cbd703f@mail.gmail.com>
	 <1235159397.5860.81.camel@rc-desk>
	 <c4d76b3b0902221610rc85a87j4b0eb0b902689dd9@mail.gmail.com>
	 <1235363865.6190.8.camel@rainbow>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 11:21:16 -0800
Message-Id: <1235416876.18617.12.camel@rc-desk> (sfid-20090223_201647_362483_8865BDE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason,

On Sun, 2009-02-22 at 20:37 -0800, Jason Andryuk wrote:
> On Sun, 2009-02-22 at 19:10 -0500, Jason Andryuk wrote:
> > On Fri, Feb 20, 2009 at 2:49 PM, reinette chatre
> > <reinette.chatre@intel.com> wrote:
> > > Running with full debugging on all the time will not be practical - but
> > > there is a debug flag that will only be used when encountering a
> > > firmware error. This flag will cause a dump of event information that
> > > will help with debugging. Would it be possible to run your driver with
> > > debug=0x40000 all the time?
> >
> > Unfortunately, debug=0x40000 results in an NULL pointer dereference in
> > iwl_dump_nic_error_log.  iwl_dump_nic_error_log+0x3a =>
> > iwl-core.c:1668.  Logs below.
> 
> Created a patch to fix the problem and got the below output.  The second
> hunk fixes the segfault.  The first hunk re-includes a ret that was
> dropped in another commit.  Without it, ret is assigned a return value
> prior to the less than zero check.  You may not want the first hunk.

Thank you very much. Both hunks are needed by the driver. Could you
please resend the patch with new description to John (cc linux-wireless)
I'll ack it when you do so.

Reinette


