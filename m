Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:52327 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934060AbcJRXwh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 19:52:37 -0400
Date: Tue, 18 Oct 2016 17:52:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: sequence diagrams in rst documentation
Message-ID: <20161018175236.75c8c4e2@lwn.net> (sfid-20161019_015242_164957_8BEE708D)
In-Reply-To: <1476791021.6425.25.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
        <20161011072119.7ad4e3a3@lwn.net>
        <1476193466.4118.10.camel@sipsolutions.net>
        <1476194038.4118.11.camel@sipsolutions.net>
        <1476791021.6425.25.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 18 Oct 2016 13:43:41 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> > Example here:
> > https://johannes.sipsolutions.net/files/80211/mac80211.html#connection-flow  
> 
> Coming back to this - sadly, it appears that this software (blockdiag,
> seqdiag) is completely unmaintained, with open pull requests dating
> back to 2012 and the last commit dating back to 2015-08-22.
> 
> I'd want/need feature improvements in it too, but if I can't feed those
> back to upstream (since it appears dead), there's little point.
> 
> Perhaps we can ship plugins for this as part of the kernel sources?
> Shouldn't be too difficult to reimplement something like this, after
> all.

OK, I've read through all of this.  My thoughts, for whatever it's worth.

We already carry a few sphinx plugins in the kernel; there is room for
more if we *really* need them.  But...

 - Part of the idea behind switching over to sphinx was to be able to get
   away from maintaining our own formatting system.  Adding plugins to the
   kernel is a step away from that goal.  So I'd like to be sure that
   there's nothing that's part of standard sphinx that will do the job
   first.

That said, I think that requiring people to install plugins from contrib
sites or third-party repos may be even worse.  We don't want to put people
through misery just to format the docs.

In summary, I think we can consider taking on a module if it's what we
need to do the docs right.  And if somebody agrees to maintain it! :)

I've heard others say they would like better diagramming support.  Do you
think that, maybe, something like aafigure would do the trick?

	https://pythonhosted.org/sphinxcontrib-aafig/

I've not actually played with it at all, but I like the idea that we'd
have readable diagrams in the source docs as well...

jon
