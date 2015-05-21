Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37884 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbbEUQab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:30:31 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 21 May 2015 22:00:28 +0530
Message-ID: <1432225809.2450.11.camel@linux.vnet.ibm.com> (sfid-20150521_183036_359447_F6D4F4B9)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org, Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 May 2015 12:30:09 -0400
In-Reply-To: <9567.1432223509@warthog.procyon.org.uk>
References: <20150519221128.GP23057@wotan.suse.de>
	 <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
	 <9567.1432223509@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-21 at 16:51 +0100, David Howells wrote:
> Luis R. Rodriguez <mcgrof@suse.com> wrote:
> 
> > I had this planned out because regulatory.bin used its own simple RSA key
> > with no x509 juju magic. I also envisioned it being easier for Kyle for
> > instance to use his own PGP key to sign linux-firmware files to start off
> > with than some complex x509 thing. Based on discussions with David, Seth,
> > and Kyle though it seems we were going to be happy with trusting Kyle's key
> > for regulatory.bin, since that will be done Kyle might as well sign all
> > linux-firmware files and folks who trust that can use it.
> 
> To go down the signature root, what the kernel needs is:
> 
>  (1) A way to get a key into the kernel.  We're currently using X.509 for this
>      for module signing and kexec.
> 
>  (2) A way to get a signature into the kernel with sufficient metadata to
>      select the key to use.  Currently, kexec uses PKCS#7 for this and module
>      signing uses a private format which I'm intending to change to PKCS#7.
> 
>      For firmware, I think Andy is right and we also need to include in the
>      metadata something that says under what circumstances the firmware can be
>      used - likely the name that is passed to request_firmware() - which must
>      also be included in the digested data.
> 
>      I don't believe that module signing actually requires a hint of this type
>      since we have to permit insmod to work and there won't be a hint we can
>      trust.  Besides, once verified, modules have to be loadable by the module
>      loader which is probably a sufficient restriction in itself.
> 
>      I don't believe that kexec signing requires a name hint either since I
>      think the only restriction on what we're allowed to kexec is that it must
>      be bootable from the beginning - and must be a PE binary on x86 type
>      platforms.
> 
> I do have patches to parse PGP key data and add the public keys found therein
> onto the kernel keyring, but that would mean adding an extra key data parser.
> 
> You could probably do this with the integrity functions - but turning them on
> has a performance cost and you have to load things in the right order as I
> understand it.

The only ordering is loading the keys before verifying the signatures.
Have you recently done any performance testing?

Mimi

