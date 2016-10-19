Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35756 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945628AbcJSPoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:44:15 -0400
Message-ID: <1476863488.5927.10.camel@sipsolutions.net> (sfid-20161019_174435_424464_55A9CFED)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Wed, 19 Oct 2016 09:51:28 +0200
In-Reply-To: <20161018175236.75c8c4e2@lwn.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <20161018175236.75c8c4e2@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 17:52 -0600, Jonathan Corbet wrote:

> In summary, I think we can consider taking on a module if it's what
> we need to do the docs right.  And if somebody agrees to maintain it!
> :)

:)

I think for the ones that we carry, they're probably specific?

> I've heard others say they would like better diagramming support.  Do
> you think that, maybe, something like aafigure would do the trick?
> 
> 	https://pythonhosted.org/sphinxcontrib-aafig/
> 
> I've not actually played with it at all, but I like the idea that
> we'd have readable diagrams in the source docs as well...

Well, maybe. I agree having it readable in the source docs as well is
nice, but for sequence diagrams in particular, I don't think

    +-------+         +-----------+
    | Hello +-------->+ aafigure! |
    +-------+         +-----------+

really beats

   Hello -> aafigure!

by much. You could do some alignment even with the latter version, and
the above isn't even really a sequence diagram anyway :)

Some of the sequence diagrams may also be automatically generated from
runtime behaviour observation (e.g. tracing, we've actually done that),
and outputting the types of ascii boxes is much more difficult there.

For other types of diagrams this may be nice though.

Anyway, I guess we'll cross that bridge when we get to it. I'd like to
have these types of documentation, perhaps with a script to auto-
generate from tracing - such as script and visual display can even
serve as a debugging aid :)

johannes
