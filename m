Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43428 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933808AbcJUVRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 17:17:55 -0400
Message-ID: <1477084667.4068.61.camel@sipsolutions.net> (sfid-20161021_231804_485759_B7C3222F)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Fri, 21 Oct 2016 23:17:47 +0200
In-Reply-To: <EFAA684D-941C-45F9-8D37-F28EF3B11F4F@darmarit.de>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <20161018175236.75c8c4e2@lwn.net>
         <1476863488.5927.10.camel@sipsolutions.net>
         <1477053099.4068.42.camel@sipsolutions.net> <87k2d1q2qx.fsf@intel.com>
         <1477055055.4068.46.camel@sipsolutions.net>
         <EFAA684D-941C-45F9-8D37-F28EF3B11F4F@darmarit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I general I think, we should not include Java into our toolchains
> even if it is optional. Thats, why I won't vote for
> http://plantuml.com/

Keep in mind though that such a vote may well end up being a vote not
just against plantuml, but also against having sequence diagrams to
start with - at least as far as I'm concerned - since we (rightfully!)
also don't want to start writing our own infrastructure (again). There
aren't many alternatives. Even seqdiag/blockdiag isn't nearly as fully
featured as plantuml.

> IMO a tool which generates SVG would be the best, I have to check
> if I find some or if some of the above could used in this way.

plantuml does create svg :->

Ultimately, I actually think it doesn't matter much whether we add java
or python or whatever to our toolchain.

As soon as we add external dependencies that have to be fulfilled
outside of the kernel git tree, and such fulfilment is easy (as it is
in "sudo apt-get install plantuml python3-sphinxcontrib.plantuml"), it
hardly matters what exactly is behind it.

So ultimately, the way I see it, we essentially have two choices:

 1) we reject external dependencies entirely, shipping everything in
    the tree that we need to build documentation
 2) we accept external dependencies, hopefully finding ways to make
    them optional

In case of 1), which we obviously don't have today since we don't ship
sphinx and everything, we're basically reduced to having very simple
python-only plugins. As far as I'm concerned this will mean that I'm
not adding such diagrams to the kernel documentation, life's too short
to rewrite something like plantuml, and I can't find anything that's
pure python (and fulfilling your - IMHO a bit exaggerated - standards).

In case of 2), as long as it's easy to install on a typical Linux
distro, I think it doesn't actually matter that it's java or whatever
else.

johannes
