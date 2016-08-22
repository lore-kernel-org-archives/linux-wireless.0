Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:35279 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752353AbcHVU4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 16:56:11 -0400
Message-ID: <1471899367.3746.78.camel@perches.com> (sfid-20160822_225635_399244_3B7AF444)
Subject: Re: [PATCH] checkpatch: See if modified files are marked obsolete
 in MAINTAINERS
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andy Whitcroft <apw@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Aug 2016 13:56:07 -0700
In-Reply-To: <30522d64-8303-cf13-d967-a5759aeb2278@users.sourceforge.net>
References: <87shtwvm63.fsf@kamboji.qca.qualcomm.com>
         <7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com>
         <30522d64-8303-cf13-d967-a5759aeb2278@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-22 at 22:50 +0200, SF Markus Elfring wrote:
> > @@ -2289,6 +2299,10 @@ sub process {
> >  		}
> >  
> >  		if ($found_file) {
> > +			if (is_maintained_obsolete($realfile)) {
> > +				WARN("OBSOLETE",
> > +				     "$realfile is marked as 'obsolete' in the MAINTAINERS hierarchy.  No unnecessary modifications please.\n");
> > +			}
> How do you think about to avoid a double negation in such a warning message?
> 
> Would a wording like "… Only really necessary modifications please.\n"
> be more useful here?

No, probably not.
