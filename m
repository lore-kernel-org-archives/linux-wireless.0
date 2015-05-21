Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbbEUPwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 11:52:43 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150519221128.GP23057@wotan.suse.de>
References: <20150519221128.GP23057@wotan.suse.de> <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 21 May 2015 16:51:49 +0100
Message-ID: <9567.1432223509@warthog.procyon.org.uk> (sfid-20150521_175300_819804_5C9C67ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@suse.com> wrote:

> I had this planned out because regulatory.bin used its own simple RSA key
> with no x509 juju magic. I also envisioned it being easier for Kyle for
> instance to use his own PGP key to sign linux-firmware files to start off
> with than some complex x509 thing. Based on discussions with David, Seth,
> and Kyle though it seems we were going to be happy with trusting Kyle's key
> for regulatory.bin, since that will be done Kyle might as well sign all
> linux-firmware files and folks who trust that can use it.

To go down the signature root, what the kernel needs is:

 (1) A way to get a key into the kernel.  We're currently using X.509 for this
     for module signing and kexec.

 (2) A way to get a signature into the kernel with sufficient metadata to
     select the key to use.  Currently, kexec uses PKCS#7 for this and module
     signing uses a private format which I'm intending to change to PKCS#7.

     For firmware, I think Andy is right and we also need to include in the
     metadata something that says under what circumstances the firmware can be
     used - likely the name that is passed to request_firmware() - which must
     also be included in the digested data.

     I don't believe that module signing actually requires a hint of this type
     since we have to permit insmod to work and there won't be a hint we can
     trust.  Besides, once verified, modules have to be loadable by the module
     loader which is probably a sufficient restriction in itself.

     I don't believe that kexec signing requires a name hint either since I
     think the only restriction on what we're allowed to kexec is that it must
     be bootable from the beginning - and must be a PE binary on x86 type
     platforms.

I do have patches to parse PGP key data and add the public keys found therein
onto the kernel keyring, but that would mean adding an extra key data parser.

You could probably do this with the integrity functions - but turning them on
has a performance cost and you have to load things in the right order as I
understand it.

The hash list idea for firmware really isn't a starter for a distribution like
Fedora and especially RHEL.  We would have to crank out a new set of kernels
any time anyone released a new firmware that someone might want to load since
the hash list is effectively dependent on *all* the firmware blobs.  Further,
you cannot ever discard any entries as you would potentially prevent someone's
system from booting if you did.

> > 3. PKCS#1 v1.5, really?  PKCS#1 v1.5 is known to be insecure unless
> > very cafefully validated.  For example:
> > 
> > https://www.imperialviolet.org/2014/09/26/pkcs1.html
> > 
> > Could we please consider using a signature scheme with a security proof?
> 
> I'm fine with going with some other alternative, now what do you have in mind?

We can look at moving to PKCS#1 v2.1 and using RSASSA-PSS.  The main
difficulty is persuading openssl that it wants to do that.

Andy Lutomirski <luto@amacapital.net> wrote:

> RSA-PSS, ECDSA over P-256, or Ed25519.  The IRTF CFRG is expected to
> publish an RFC for a modern signature scheme any day^Wmonth^Wyear now,
> too.

These are public key algorithms, not message/certificate formats, so comparing
X.509 or PKCS#7 to ECDSA or Ed25519 is not valid.

David
