Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbESPqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 11:46:35 -0400
Date: Tue, 19 May 2015 17:46:30 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency when
 fw signing is enabled
Message-ID: <20150519154630.GB23057@wotan.suse.de> (sfid-20150519_174707_883315_E907653B)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
 <20150506033330.GA16470@gondor.apana.org.au>
 <1430988137.8171.58.camel@x220>
 <1431021995.8171.97.camel@x220>
 <20150518200100.GY23057@wotan.suse.de>
 <1431981930.9091.29.camel@x220>
 <20150519000921.GA23057@wotan.suse.de>
 <1432022535.9091.48.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432022535.9091.48.camel@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 10:02:15AM +0200, Paul Bolle wrote:
> On Tue, 2015-05-19 at 02:09 +0200, Luis R. Rodriguez wrote:
> > On Mon, May 18, 2015 at 10:45:30PM +0200, Paul Bolle wrote:
> > > [...] so, probably, almost
> > > all .config files have FW_LOADER set. So I think, except for some corner
> > > cases, either converting all "select FW_LOADER" to "depends on
> > > FW_LOADER" or simply dropping  "select FW_LOADER" all together, should
> > > be fine.
> > 
> > Well, that makes sense. I just dropped all "select FW_LOADER" entries
> > on next-20150518, then I enabled everything with 'make allyesconfig'
> > and then went into menuconfig to disable FW_LOADER. The build worked.
> > 
> > Going to try a few more build matrix combinations and send patches to
> > do away with this.
> > 
> > > Those corner cases should then be handled on a case by case basis. 
> 
> Having slept on this, it occurred to me a randconfig could hit those
> corner cases. (Make that will hit them, actually.) Of course, one might
> argue that randconfig and EXPERT's advice, "Only use this if you really
> know what you are doing.", are at odds. Which opens another can of
> worms: how much do we care about .config files in which randconfig
> visited the kernels darker corners? Just enough, I'm afraid.
> 
> So it seems I've wasted your time by suggesting to drop those selects.

IMHO not at all.

> And now I wonder what trouble using "depends on" will generate here...

Instead of depends on we should just drop it and and issues arise we
should fix them provided an allyesconfig and allmodconfig work when
FW_LOADER is disabled. That was the approach I wanted to take at
least. To make this easier to phase we can break it down by subsystem.

Thoughts?

 Luis
