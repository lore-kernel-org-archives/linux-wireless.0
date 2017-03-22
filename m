Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758814AbdCVPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 11:16:29 -0400
Date: Wed, 22 Mar 2017 16:15:26 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
Message-ID: <20170322151525.GA12702@redhat.com> (sfid-20170322_161632_885079_2FB127AF)
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
 <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
 <1489866302.13995.3.camel@sipsolutions.net>
 <45449c16-5a51-5cec-3254-6f3ce0b71b8a@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45449c16-5a51-5cec-3254-6f3ce0b71b8a@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 18, 2017 at 04:30:04PM -0500, Larry Finger wrote:
> On 03/18/2017 02:45 PM, Johannes Berg wrote:
> >On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
> >>
> >>I have duplicated your bug and I have bisected it to
> >>
> >>commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
> >>Author: Johannes Berg <johannes.berg@intel.com>
> >>Date:   Mon Oct 24 14:40:04 2016 +0200
> >>
> >>     genetlink: use idr to track families
> >>
> >>This patch is quite extensive and I have no idea which part is
> >>failing, thus all I can do is report this confirmation.
> >
> >I don't think that makes any sense - have you verified that reverting
> >that makes it go away?
> 
> Due to conflicts, I cannot simply revert it; however if I check out
> the previous commit 489111e5c25b93be80340c3113d71903d7c82136
> ("genetlink: statically initialize families"), then the kernel is
> OK.

I just posted a patch which most likely fixes this problem. I have some
other issue on my setup, but seems this issue is also caused by the
same bug in 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a.

Stanislaw
