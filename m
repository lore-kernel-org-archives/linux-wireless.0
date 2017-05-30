Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57478 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdE3NXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 09:23:10 -0400
Message-ID: <1496150587.3327.11.camel@sipsolutions.net> (sfid-20170530_152317_055924_7FFFC4AA)
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add
 "unused-functions"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Date: Tue, 30 May 2017 15:23:07 +0200
In-Reply-To: <8737do3a7i.fsf@intel.com>
References: <20170331071632.6209-1-johannes@sipsolutions.net>
         <878tnl38ur.fsf@intel.com> <1491249573.4714.3.camel@sipsolutions.net>
         <8737do3a7i.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-04 at 10:26 +0300, Jani Nikula wrote:
> 
> > Interesting, TBH I never even considered this. How would I even run
> > it that way? Presumably "make htmldocs" doesn't do this?
> 
> Try 'make SPHINXOPTS=-j8 htmldocs'.

Yep, makes sense.

> > Sphinx documentation (http://www.sphinx-doc.org/en/stable/extdev/) says
> > this:
> > 
> >     The setup() function can return a dictionary. This is treated by
> >     Sphinx as metadata of the extension. Metadata keys currently
> >     recognized are:
> >     [...]
> >     'parallel_read_safe': a boolean that specifies if parallel reading
> >     of source files can be used when the extension is loaded. It
> >     defaults to False, i.e. you have to explicitly specify your
> >     extension to be parallel-read-safe after checking that it is.
> > 
> >     We do set this right now, so I guess it'd only be guaranteed to work
> >     right within a single rst file, and then I should perhaps consider not
> >     making this state global but somehow linking it to the rst file being
> >     processed?
> 
> Perhaps, but does that defeat the purpose then?

Yeah, it kinda does. For my original use case in cfg80211 we only have
a single file, but even in mac80211 we already use more than one.

Not sure what to do then - I guess we just can't do that, unless we
prevent using this with parallelization, which seems awkward.

johannes
