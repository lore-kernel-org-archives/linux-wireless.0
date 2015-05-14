Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48844 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbbENDEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 23:04:42 -0400
Date: Thu, 14 May 2015 11:04:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [RFC v2 3/6] crypto: qat - address recursive dependency when fw
 signing is enabled
Message-ID: <20150514030415.GD3853@gondor.apana.org.au> (sfid-20150514_050448_698209_2DC4B60C)
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-4-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431541436-17007-4-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2015 at 11:23:53AM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> We're going to add firmware module signing support, but when we do
> this we end up with the following recursive dependency. Fix this by
> just depending on FW_LOADER, which is typically always enabled
> anyway. We do this as a compromise for now as FW_LOADER is only
> selectable when EXPERT is enabled and the recursive dependency issue
> below is actually real and valid, its proper fix however requires
> a bit of work.
> 
> This technically means this change is likely welcomed for other
> parts of the kernel but this is really only needed for now here.

Nack.  Either fix kbuild or make every user of FW_LOADER use
a dependency.  Singling out a single crypto device makes zero
sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
