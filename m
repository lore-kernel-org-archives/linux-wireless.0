Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.windriver.com ([192.103.53.11]:44668 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbdDDBzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 21:55:15 -0400
Date: Mon, 3 Apr 2017 21:55:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, kbuild test robot <lkp@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        <linux-ia64@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] nfc: don't be making arch specific unaligned
 decisions at driver level.
Message-ID: <20170404015508.GS2713@windriver.com> (sfid-20170404_035546_059735_C931C06D)
References: <201701090839.5u37Hdez%fengguang.wu@intel.com>
 <20170109175222.3162-1-paul.gortmaker@windriver.com>
 <20170401222244.GF22034@zurbaran.ger.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20170401222244.GF22034@zurbaran.ger.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Re: [PATCH v2] nfc: don't be making arch specific unaligned decisions at driver level.] On 02/04/2017 (Sun 00:22) Samuel Ortiz wrote:

> Hi Paul,
> 
> On Mon, Jan 09, 2017 at 12:52:22PM -0500, Paul Gortmaker wrote:
> > Currently ia64 fails building allmodconfig with variations of:
> > 
> >    In file included from drivers/nfc/nxp-nci/i2c.c:39:0:
> >    ./include/linux/unaligned/access_ok.h:62:29: error: redefinition of ‘put_unaligned_be64’

[...]

> > 
> > The decision of what variant for unaligned access to use needs to be
> > left to the arch level and not used at the driver level.  Since not
> > all arch will have sourced asm/unaligned.h already, we need to call
> > it out and then the arch can give us just the one definition that
> > is needed.
> > 
> > See commit 064106a91be5 ("kernel: add common infrastructure for
> > unaligned access") as a reference.
> > 

[...]

> This build issue is now fixed in nfc-next with a couple of different
> patches.

I added nfc-next as a remote and saw you pulled similar commits out of
the NFC backlog just recently:

commit 2eee74b7e2a496dea49847c36fd09320505f45b7
Author:     Guenter Roeck <linux@roeck-us.net>
AuthorDate: Sat Aug 1 06:59:29 2015 -0700
Commit:     Samuel Ortiz <sameo@linux.intel.com>
CommitDate: Sat Apr 1 23:52:25 2017 +0200

    NFC: nxp-nci: Include unaligned.h instead of access_ok.h

...and...

commit d916d923724d59cde99ee588f15eec59dd863bbd
Author:     Tobias Klauser <tklauser@distanz.ch>
AuthorDate: Wed Oct 26 11:00:12 2016 +0200
Commit:     Samuel Ortiz <sameo@linux.intel.com>
CommitDate: Sat Apr 1 23:45:31 2017 +0200

    NFC: nfcmrvl: Include unaligned.h instead of access_ok.h

Thanks for finding those in the backlog and folding them in; presumably
the backlog was related to the MAINTAINERS change on the same branch.

Anyway, they appear to be the same as the change I proposed, and I build
tested nfc-next on ia64 and x86-64 without issue.  So it looks good.

One thing I did notice, is that nfc-next doesn't appear to be merged
into the linux-next trees, which explains why I didn't see a conflict
with my patch against your two new commits.  Given the recent maintainer
change you added, it seems your nfc-next is now the unconditional source
for NFC changes.  So maybe you want to ask Stephen (Cc:'d) to add your
tree to the daily linux-next coverage?

All he needs is the repo and branch, which I assume are:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git #master

Well, that and the request for it really should come from you... :)

Thanks,
Paul.
--

> 
> Cheers,
> Samuel.
