Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56105 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbbETJBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 05:01:02 -0400
Message-ID: <1432112455.21715.70.camel@x220> (sfid-20150520_110126_852204_4D0EAD31)
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency
 when fw signing is enabled
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
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
Date: Wed, 20 May 2015 11:00:55 +0200
In-Reply-To: <20150520024925.GA7021@gondor.apana.org.au>
References: <1430988137.8171.58.camel@x220> <1431021995.8171.97.camel@x220>
	 <20150518200100.GY23057@wotan.suse.de> <1431981930.9091.29.camel@x220>
	 <20150519000921.GA23057@wotan.suse.de> <1432022535.9091.48.camel@x220>
	 <20150519154630.GB23057@wotan.suse.de>
	 <20150519225945.GB5718@gondor.apana.org.au>
	 <20150519230355.GA5853@gondor.apana.org.au>
	 <CAB=NE6XizmKMc80rLV9YTZGtEJdZ022+0HNPxXvunp5v4BnCMw@mail.gmail.com>
	 <20150520024925.GA7021@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 10:49 +0800, Herbert Xu wrote:
> On Tue, May 19, 2015 at 04:05:43PM -0700, Luis R. Rodriguez wrote: 
> > Well that's be true if FW_LOADER was easy to disable, but its not. You
> > really gotta try hard to disable it. Not only does it require EXPERT
> > but also EMBEDDED.

How does that require EMBEDDED?

>  I think its fair to say if you disable FW_LOADER
> > you know what you are doing and its fair for us then to remove such
> > selects or depends. Thoughts?
> 
> Sure.  I can live with killing all selects/depends on FW_LOADER.

(Having reread my mail from the day before yesterday once more, I note
that my suggestion to drop the selects is rather circular. Because it's
the selects that also make it hard to disable FW_LOADER.)

So the message is something like: "If you set EXPERT and disable
FW_LOADER you're on your own. You have to figure out yourself whether
the configuration you chose builds or actually runs correctly. Don't
expect us to care about the issues you run into. And that goes for
randconfig builds that happen to do that too."

That might be an acceptable thing to say. The help for EXPERT is pretty
clear. But I do wonder if this is a first or if this has been done
before (ie, whether there's a precedent). Because, generally speaking,
people try rather hard to prevent pointless configurations.


Paul Bolle

