Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:59026 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934384AbcJUQL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 12:11:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: sequence diagrams in rst documentation
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <1477055055.4068.46.camel@sipsolutions.net>
Date: Fri, 21 Oct 2016 18:11:10 +0200
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Message-Id: <EFAA684D-941C-45F9-8D37-F28EF3B11F4F@darmarit.de> (sfid-20161021_181131_391751_8E2F794F)
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <20161018175236.75c8c4e2@lwn.net> <1476863488.5927.10.camel@sipsolutions.net> <1477053099.4068.42.camel@sipsolutions.net> <87k2d1q2qx.fsf@intel.com> <1477055055.4068.46.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 21.10.2016 um 15:04 schrieb Johannes Berg <johannes@sipsolutions.net>:

>> I had the same conclusion for math:: directives pulling in latex
>> dependency [1]. Hopefully Markus can help here.
> 
> Yeah, good one.
> 
> Maybe it's actually simple? Depending on where sphinx will look for
> plugins first, we could just ship the plugins with a no-op
> implementation (pass through the text as pre-formatted text), and if it
> finds the plugin first in a system-wide path that version would win for
> the better rendering?

Yes and No. It depends on the tools (toolchains) we want to use.
As far as I can see from a abstract POV it should by simple for
math:: / since we already use/need LaTeX for PDF, for other tools
I have to look.

I general I think, we should not include Java into our toolchains
even if it is optional. Thats, why I won't vote for http://plantuml.com/

aafigure: has dependencies [1] to reportlab (which is IMO inapposite) and
PIL, which is outdated / and aafigure itself seems outdated [2].

seqdiag: requires blockdiag and this requires Pillow ... until here 
its seems not bad, but there is also some "optional" dependencies to 
ImageMagick and reportlab (both smells).

IMO a tool which generates SVG would be the best, I have to check
if I find some or if some of the above could used in this way.

For this I need time ;-) ... ATM I work in a custom project but
I hope I will find next week time to dig more deeper.

-- Markus -- 
  
[1] https://pythonhosted.org/sphinxcontrib-aafig/#requirements
[2] http://bazaar.launchpad.net/~aafigure-team/aafigure/trunk/files
