Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43905 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0EFSaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:30:22 -0400
Date: Thu, 6 May 2010 14:22:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Adel Gadllah <adel.gadllah@gmail.com>
Subject: Re: [PATCH] iwlwifi: recalculate average tpt if not current
Message-ID: <20100506182232.GB4167@tuxdriver.com>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
 <1272908934.7879.5748.camel@rchatre-DESK>
 <1272909307.7879.5759.camel@rchatre-DESK>
 <1273162268.2226.2503.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1273162268.2226.2503.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 06, 2010 at 09:11:08AM -0700, reinette chatre wrote:
> On Mon, 2010-05-03 at 10:55 -0700, reinette chatre wrote:
> > From: Reinette Chatre <reinette.chatre@intel.com>
> > 
> > We currently have this check as a BUG_ON, which is being hit by people.
> > Previously it was an error with a recalculation if not current, return that
> > code.
> > 
> > The BUG_ON was introduced by:
> > commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
> > Author: Guy Cohen <guy.cohen@intel.com>
> > Date:   Tue Sep 9 10:54:54 2008 +0800
> > 
> >     iwlwifi: Added support for 3 antennas
> > 
> > ... the portion adding the BUG_ON is reverted since we are encountering the error
> > and BUG_ON was created with assumption that error is not encountered.
> > 
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> 
> I noticed this patch in your wireless-next-2.6 pull request. Since it is
> addressing a system hang issue, could it perhaps be included in
> wireless-2.6 also? I should have included the bug report reference for
> this purpose, sorry ... it is
> https://bugzilla.redhat.com/show_bug.cgi?id=588021

I didn't send it that way because a) that code has been there for a
really long time; and b) the reporter couldn't reliably reproduce
the bug and therefore can't reliably test the fix.  While I agree
that the fix looks harmless, no update is zero-risk.

Can you reliably hit that code?  Has it been tested enough that we
should risk holding-up 2.6.34's release for it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
