Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:51456 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab0CECAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 21:00:10 -0500
From: Kel Modderman <kel@otaku42.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Date: Fri, 5 Mar 2010 12:00:01 +1000
Cc: linux-wireless@vger.kernel.org
References: <201003050008.51066.kel@otaku42.de> <20100305013721.GA3255@tuxdriver.com> <201003051156.11922.kel@otaku42.de>
In-Reply-To: <201003051156.11922.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003051200.01511.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 March 2010 11:56:11 Kel Modderman wrote:
> On Friday 05 March 2010 11:37:22 John W. Linville wrote:
> > On Fri, Mar 05, 2010 at 10:27:03AM +1000, Kel Modderman wrote:
> > > On Friday 05 March 2010 01:31:28 John W. Linville wrote:
> > > > On Fri, Mar 05, 2010 at 12:08:50AM +1000, Kel Modderman wrote:
> > > > > When USE_OPENSSL=1 do not embed crypto data into binary, use the PUBKEY_DIR
> > > > > variable just as it is when USE_GCRYPT=1 and just load certs from PUBKEY_DIR
> > > > > for signature verification at runtime. Remove ssl support from
> > > > > utils/key2pub.py.
> > > > > 
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
> 
> wireless-regdb can be built from source, when it does so it generates a new
> custom key which is installed to /lib/crda/pubkeys/<key>. Your key is also
> installed here, oh but hang on, its also embedded into the binary so why bother
> installing it at all? Alright, so we can manually move our custom generated
> key from /lib/crda/pubkeys/<key> to /etc/wireless-regdb/pubkeys/<key> and things
> will probably be okay next time we build wireless-regdb and upgrade it
> independently of crda, except for:
> 1. we now have /lib/crda/pubkeys/linville.pub.pem for no reason at all
> 2. the distribution is installing to /etc/wireless-regdb/pubkeys/ which should
>    be reserved for the admin
> 3. you're maintaining a bunch of useless code which embeds openssl data into
>    binaries when you do not have to

4. if your key changes, and we have built and upgraded wireless-regdb and not
   crda then the embedded crypto data and /lib/crda/pubkeys/linville.pub.pem
   won't help

> 
> These 3 points is what my patch attempts to address.

4 points

Thanks, Kel. 
