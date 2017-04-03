Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55112 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751692AbdDCT7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 15:59:38 -0400
Message-ID: <1491249573.4714.3.camel@sipsolutions.net> (sfid-20170403_215941_597752_06BD0940)
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add
 "unused-functions"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Date: Mon, 03 Apr 2017 21:59:33 +0200
In-Reply-To: <878tnl38ur.fsf@intel.com>
References: <20170331071632.6209-1-johannes@sipsolutions.net>
         <878tnl38ur.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 15:54 +0300, Jani Nikula wrote:
> 
> I'm sure the parameter name could be improved to capture what you
> mean better; alas I don't have a suggestion.

Yes, that's a fair point - perhaps "functions-not-linked" or something
like that.

> > Internally this works by collecting (per-file) those functions
> > (and enums, structs, doc sections...) that are explicitly used,
> > and invoking the kernel-doc script with "-nofunction" later.
> 
> A quick thought that I don't have the time to check now, but should
> be checked before merging: Is the order of directive extension
> execution deterministic if the Sphinx run is parallelized (sphinx-
> build -j)? Is it deterministic within an rst file? Surely it's not
> deterministic when called from several rst files? The latter is,
> perhaps, acceptable, but the former not.

Interesting, TBH I never even considered this. How would I even run it
that way? Presumably "make htmldocs" doesn't do this?

Sphinx documentation (http://www.sphinx-doc.org/en/stable/extdev/) says
this:

    The setup() function can return a dictionary. This is treated by
    Sphinx as metadata of the extension. Metadata keys currently
    recognized are:
    [...]
    'parallel_read_safe': a boolean that specifies if parallel reading
    of source files can be used when the extension is loaded. It
    defaults to False, i.e. you have to explicitly specify your
    extension to be parallel-read-safe after checking that it is.

    We do set this right now, so I guess it'd only be guaranteed to work
    right within a single rst file, and then I should perhaps consider not
    making this state global but somehow linking it to the rst file being
    processed?

    johannes
