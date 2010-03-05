Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46474 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0CEEKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 23:10:40 -0500
Date: Thu, 4 Mar 2010 23:08:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kel Modderman <kel@otaku42.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Message-ID: <20100305040853.GA4640@tuxdriver.com>
References: <201003050008.51066.kel@otaku42.de>
 <201003051027.03091.kel@otaku42.de>
 <20100305013721.GA3255@tuxdriver.com>
 <201003051156.11922.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201003051156.11922.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 05, 2010 at 11:56:11AM +1000, Kel Modderman wrote:
> On Friday 05 March 2010 11:37:22 John W. Linville wrote:
> > On Fri, Mar 05, 2010 at 10:27:03AM +1000, Kel Modderman wrote:
> > > On Friday 05 March 2010 01:31:28 John W. Linville wrote:
> > > > On Fri, Mar 05, 2010 at 12:08:50AM +1000, Kel Modderman wrote:

> > > > > This allows wireless-regdb to be built from source and upgraded independently
> > > > > of crda and is _crucial_ for distributions who want to build their own
> > > > > regulatory.bin.
> > > > 
> > > > I don't understand -- isn't this possible already?
> > > 
> > > No.
> > 
> > Perhaps you could use a few more words?  It seems to me that what
> > limits you is the policies of some distributions.  Certainly crda
> > and wireless-regdb can be maintained separately so long as the key
> > doesn't change between builds or with alternate keys installed in
> > the proper locations.  Am I missing something?
> 
> Yes you are missing something. Its not the policy of my distribution which
> is limiting its the design of the crda/wireless-regdb build systems.
> 
> Now that openssl support allows reading pubkeys at runtime, the  embedding
> of crypto data into binaries can be totally removed when built with openssl.

I don't think anyone said that this change could not be made.
I merely challenged the flawed reasoning you asserted for its need.

> wireless-regdb can be built from source, when it does so it generates a new
> custom key which is installed to /lib/crda/pubkeys/<key>. Your key is also
> installed here, oh but hang on, its also embedded into the binary so why bother
> installing it at all? Alright, so we can manually move our custom generated
> key from /lib/crda/pubkeys/<key> to /etc/wireless-regdb/pubkeys/<key> and things
> will probably be okay next time we build wireless-regdb and upgrade it
> independently of crda, except for:

Why would you need to move it?  Did someone break the code that uses
regdb_paths in crda.c?  Does PUBKEY_DIR not work?

> 1. we now have /lib/crda/pubkeys/linville.pub.pem for no reason at all

If you don't want my key (or any other) in your binary then simply
delete it from crda/pubkeys in your build scripts...?

> 2. the distribution is installing to /etc/wireless-regdb/pubkeys/ which should
>    be reserved for the admin

"make PUBKEY_DIR=/lib/crda/pubkeys"?

> 3. you're maintaining a bunch of useless code which embeds openssl data into
>    binaries when you do not have to

See rebuttal to #1...just because you don't use some functionality
doesn't mean no one else wants it or uses it.

> These 3 points is what my patch attempts to address.

It seems to me that you address the points by simply removing
functionality rather than using other means that already exist to
address the same concerns.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
