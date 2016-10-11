Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34677 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753260AbcJKOOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 10:14:34 -0400
Message-ID: <1476192636.4118.8.camel@sipsolutions.net> (sfid-20161011_161437_673328_61861541)
Subject: Re: [PATCH] docs-rst: sphinxify 802.11 documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Oct 2016 15:30:36 +0200
In-Reply-To: <20161011072119.7ad4e3a3@lwn.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Jon, unless you have strong objections, I'd like to take this
> > through my tree due to the header file changes.
> 
> Is there any chance of splitting those two things up?  In particular,
> index.rst has become a real conflict point, and I'm getting tired of
> explaining those to Linus...so I'd prefer to carry that part if
> possible.

Hmm. It may be easier then to take this through your tree entirely.

I could split it, and ask you to add only the index.rst change.
However, if this is a contention point, then the DocBook/Makefile will
also be the same contention point at least as far as conversions are
concerned, and if I don't have *that* in my tree either then the
(documentation) build will be broken by the removal of the template.

So ultimately then it'll be better for you to just take almost all of
the conversion through your tree.

The header file changes normally wouldn't be a big deal, they're in
comments only, but in this case I know that we have a work-in-progress
patch submission that will change things here, and I'd like that to
already use the new format.

Maybe I can just take the relevant header file change through my tree?

It would cause the following warning to appear in your tree:

include/net/cfg80211.h:3093: WARNING: Definition list ends without a blank line; unexpected unindent.
include/net/cfg80211.h:3095: ERROR: Unexpected indentation.
include/net/cfg80211.h:3099: WARNING: Block quote ends without a blank line; unexpected unindent.
include/net/cfg80211.h:3107: WARNING: Definition list ends without a blank line; unexpected unindent.
include/net/cfg80211.h:3109: ERROR: Unexpected indentation.
include/net/cfg80211.h:3113: WARNING: Block quote ends without a blank line; unexpected unindent.
include/net/cfg80211.h:3123: ERROR: Unexpected indentation.
include/net/cfg80211.h:3124: WARNING: Definition list ends without a blank line; unexpected unindent.
include/net/cfg80211.h:3126: ERROR: Unexpected indentation.
include/net/cfg80211.h:3130: WARNING: Block quote ends without a blank line; unexpected unindent.

for the time being - perhaps you can live with that, until my changes
also propagate through to the tree?

Alternatively, I could merge the header file change, and hold this
patch until my changes hit the tree, but that will be a long time
coming, presumably, since I'll have missed the merge window with both
of the changes.

johannes
