Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964860AbbENTev (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 15:34:51 -0400
Date: Thu, 14 May 2015 21:34:45 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, Kyle McMartin <kyle@kernel.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [RFC v2 3/6] crypto: qat - address recursive dependency when fw
 signing is enabled
Message-ID: <20150514193445.GW23057@wotan.suse.de> (sfid-20150514_213517_021750_12B21BC7)
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-4-git-send-email-mcgrof@do-not-panic.com>
 <20150514030415.GD3853@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150514030415.GD3853@gondor.apana.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2015 at 11:04:15AM +0800, Herbert Xu wrote:
> On Wed, May 13, 2015 at 11:23:53AM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > We're going to add firmware module signing support, but when we do
> > this we end up with the following recursive dependency. Fix this by
> > just depending on FW_LOADER, which is typically always enabled
> > anyway. We do this as a compromise for now as FW_LOADER is only
> > selectable when EXPERT is enabled and the recursive dependency issue
> > below is actually real and valid, its proper fix however requires
> > a bit of work.
> > 
> > This technically means this change is likely welcomed for other
> > parts of the kernel but this is really only needed for now here.
> 
> Nack.  Either fix kbuild or make every user of FW_LOADER use
> a dependency.  Singling out a single crypto device makes zero
> sense.

I think that's fair... Paul, did you get to look into the
recursive issue some more by any chance? Any preference for
what path to take here?

  Luis
