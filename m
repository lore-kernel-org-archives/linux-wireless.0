Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:51844 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750951AbdJDRz0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 13:55:26 -0400
Message-ID: <1507139722.4434.12.camel@perches.com> (sfid-20171004_195550_140651_4F3CAE83)
Subject: Re: [PATCH 1/3] wireless: iwlwifi: use bool instead of int
From: Joe Perches <joe@perches.com>
To: Luciano Coelho <luciano.coelho@intel.com>,
        Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
        <christoph@boehmwalder.at>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Oct 2017 10:55:22 -0700
In-Reply-To: <1507135159.908.96.camel@intel.com>
References: <20171004155700.18048-1-christoph@boehmwalder.at>
         <20171004155700.18048-2-christoph@boehmwalder.at>
         <1507134405.4434.10.camel@perches.com> <1507135159.908.96.camel@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-04 at 19:39 +0300, Luciano Coelho wrote:
> On Wed, 2017-10-04 at 09:26 -0700, Joe Perches wrote:
[]
> > This might be more intelligble as separate tests
> > 
> > static bool is_valid_channel(u16 ch_id)
> > {
> > 	if (ch_id <= 14)
> > 		return true;
> > 
> > 	if ((ch_id % 4 == 0) &&
> > 	    ((ch_id >= 36 && ch_id <= 64) ||
> > 	     (ch_id >= 100 && ch_id <= 140)))
> > 		return true;
> > 
> > 	if ((ch_id % 4 == 1) &&
> > 	    (chid >= 145 && ch_id <= 165))
> > 		return true;
> > 
> > 	return false;
> > }
> > 
> > The compiler should produce the same object code.
> 
> Yeah, it may be a bit easier to read, but I don't want to start getting
> "fixes" to working and reasonable code.  There's nothing wrong with the
> existing function (except maybe for the int vs. boolean) so let's not
> change it.
> 
> A good time to change this would be the next time someone adds yet
> another range of valid channels here. ;)

<shrug>  Your choice.

I like code I can read and understand at a glance.

At case somebody needs to add channels, likely nobody
would do the change suggested but would just add
another test to the already odd looking block.

And constants should be on the right side of the tests.
