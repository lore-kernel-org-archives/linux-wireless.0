Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0EFSuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:50:17 -0400
Subject: Re: [PATCH] iwlwifi: recalculate average tpt if not current
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Adel Gadllah <adel.gadllah@gmail.com>
In-Reply-To: <20100506182232.GB4167@tuxdriver.com>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	 <1272908934.7879.5748.camel@rchatre-DESK>
	 <1272909307.7879.5759.camel@rchatre-DESK>
	 <1273162268.2226.2503.camel@rchatre-DESK>
	 <20100506182232.GB4167@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 11:50:15 -0700
Message-ID: <1273171815.2370.247.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, 2010-05-06 at 11:22 -0700, John W. Linville wrote:
> On Thu, May 06, 2010 at 09:11:08AM -0700, reinette chatre wrote:
> > I noticed this patch in your wireless-next-2.6 pull request. Since it is
> > addressing a system hang issue, could it perhaps be included in
> > wireless-2.6 also? I should have included the bug report reference for
> > this purpose, sorry ... it is
> > https://bugzilla.redhat.com/show_bug.cgi?id=588021
> 
> I didn't send it that way because a) that code has been there for a
> really long time; and b) the reporter couldn't reliably reproduce
> the bug and therefore can't reliably test the fix.  While I agree
> that the fix looks harmless, no update is zero-risk.
> 
> Can you reliably hit that code?  Has it been tested enough that we
> should risk holding-up 2.6.34's release for it?

Good point ... we have not seen this BUG being hit before and it seems
to have been there since 2.6.28.  In addition to the report in RedHat
bugzilla there is a lkml thread that seems to be related to this code
also (http://lkml.org/lkml/2010/5/3/229 ) ... but that reporter did not
seem to test this patch and my last reply to that thread bounced to his
email address.

We thus seem to have two recent reports of users hitting the BUG, which
may mean some other recent change in driver causes this BUG to be hit,
not really just the presence of the BUG code itself.

As far as testing goes ... this patch has just been merged and will from
now on be included in our regression testing. Unfortunately this had not
been exercised much yet since I just merged.

I guess we will proceed with the "wait and see" here and forward this
patch to stable if the BUG is encountered again.

Reinette
 


