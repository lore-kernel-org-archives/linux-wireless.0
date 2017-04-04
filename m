Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36220 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdDDH0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 03:26:22 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add "unused-functions"
In-Reply-To: <1491249573.4714.3.camel@sipsolutions.net>
References: <20170331071632.6209-1-johannes@sipsolutions.net> <878tnl38ur.fsf@intel.com> <1491249573.4714.3.camel@sipsolutions.net>
Date: Tue, 04 Apr 2017 10:26:09 +0300
Message-ID: <8737do3a7i.fsf@intel.com> (sfid-20170404_092626_599777_28A7FBC7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 03 Apr 2017, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2017-03-31 at 15:54 +0300, Jani Nikula wrote:
>> 
>> I'm sure the parameter name could be improved to capture what you
>> mean better; alas I don't have a suggestion.
>
> Yes, that's a fair point - perhaps "functions-not-linked" or something
> like that.
>
>> > Internally this works by collecting (per-file) those functions
>> > (and enums, structs, doc sections...) that are explicitly used,
>> > and invoking the kernel-doc script with "-nofunction" later.
>> 
>> A quick thought that I don't have the time to check now, but should
>> be checked before merging: Is the order of directive extension
>> execution deterministic if the Sphinx run is parallelized (sphinx-
>> build -j)? Is it deterministic within an rst file? Surely it's not
>> deterministic when called from several rst files? The latter is,
>> perhaps, acceptable, but the former not.
>
> Interesting, TBH I never even considered this. How would I even run it
> that way? Presumably "make htmldocs" doesn't do this?

Try 'make SPHINXOPTS=-j8 htmldocs'.

>
> Sphinx documentation (http://www.sphinx-doc.org/en/stable/extdev/) says
> this:
>
>     The setup() function can return a dictionary. This is treated by
>     Sphinx as metadata of the extension. Metadata keys currently
>     recognized are:
>     [...]
>     'parallel_read_safe': a boolean that specifies if parallel reading
>     of source files can be used when the extension is loaded. It
>     defaults to False, i.e. you have to explicitly specify your
>     extension to be parallel-read-safe after checking that it is.
>
>     We do set this right now, so I guess it'd only be guaranteed to work
>     right within a single rst file, and then I should perhaps consider not
>     making this state global but somehow linking it to the rst file being
>     processed?

Perhaps, but does that defeat the purpose then?

BR,
Jani.

>
>     johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jani Nikula, Intel Open Source Technology Center
