Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbbETVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 17:19:38 -0400
Date: Wed, 20 May 2015 23:19:30 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Kyle McMartin <kyle@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, jlee@suse.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency when
 fw signing is enabled
Message-ID: <20150520211930.GA23057@wotan.suse.de> (sfid-20150520_231955_759679_283AD340)
References: <20150518200100.GY23057@wotan.suse.de>
 <1431981930.9091.29.camel@x220>
 <20150519000921.GA23057@wotan.suse.de>
 <1432022535.9091.48.camel@x220>
 <20150519154630.GB23057@wotan.suse.de>
 <20150519225945.GB5718@gondor.apana.org.au>
 <20150519230355.GA5853@gondor.apana.org.au>
 <CAB=NE6XizmKMc80rLV9YTZGtEJdZ022+0HNPxXvunp5v4BnCMw@mail.gmail.com>
 <20150520024925.GA7021@gondor.apana.org.au>
 <1432112455.21715.70.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432112455.21715.70.camel@x220>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 11:00:55AM +0200, Paul Bolle wrote:
> On Wed, 2015-05-20 at 10:49 +0800, Herbert Xu wrote:
> > On Tue, May 19, 2015 at 04:05:43PM -0700, Luis R. Rodriguez wrote: 
> > > Well that's be true if FW_LOADER was easy to disable, but its not. You
> > > really gotta try hard to disable it. Not only does it require EXPERT
> > > but also EMBEDDED.
> 
> How does that require EMBEDDED?

Sorry not embedded, not sure where I got that from, for some reason
I though you had mentioned that.

> >  I think its fair to say if you disable FW_LOADER
> > > you know what you are doing and its fair for us then to remove such
> > > selects or depends. Thoughts?
> > 
> > Sure.  I can live with killing all selects/depends on FW_LOADER.
> 
> (Having reread my mail from the day before yesterday once more, I note
> that my suggestion to drop the selects is rather circular. Because it's
> the selects that also make it hard to disable FW_LOADER.)
> 
> So the message is something like: "If you set EXPERT and disable
> FW_LOADER you're on your own. You have to figure out yourself whether
> the configuration you chose builds

I think we can attest that it will build, otherwise we should fix.

> or actually runs correctly.

Whether it will run in this case will depend on whether or not
the firmware was needed or not, if it was it won't. Note that
there is a FW API call which implies "this is optional firmware",
its the request_firmware_direct() call but this call is synchronous,
we have no option for asynchronous behaviour. I intend to add support
for that but that requires a bit of changes. Also, based on my review
its a fair assumption that most calls to the FW APIs mean they need
it. The only ones we can be sure are optional are the ones using
request_firmware_direct().

> Don't
> expect us to care about the issues you run into. And that goes for
> randconfig builds that happen to do that too."

I think its fair to expect us to fix randconfig build issues, but not
runtime issues.

> That might be an acceptable thing to say. The help for EXPERT is pretty
> clear. But I do wonder if this is a first or if this has been done
> before (ie, whether there's a precedent). Because, generally speaking,
> people try rather hard to prevent pointless configurations.

Yeah sure, we even let your system go out of regulatory compliance,
see CFG80211_CERTIFICATION_ONUS, and CFG80211_REG_CELLULAR_HINTS.
Then with CFG80211_INTERNAL_REGDB the parser right now lacks support
for a few new bells and whistles and requires expert knowledge how
to properly build and integrate all new bells and whistles. It seemed
folks were OK with this.

  Luis
