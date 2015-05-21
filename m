Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33681 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbbEUQkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:40:13 -0400
Received: by lbbzk7 with SMTP id zk7so22368176lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 09:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9567.1432223509@warthog.procyon.org.uk>
References: <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
 <20150519221128.GP23057@wotan.suse.de> <9567.1432223509@warthog.procyon.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 May 2015 09:39:50 -0700
Message-ID: <CALCETrX3krCsqCLvLYx1QdnjFK=R8FF7ta=vozDcGYSTUHvSrA@mail.gmail.com> (sfid-20150521_184024_520132_5F0936A2)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Joey Lee <jlee@suse.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Kyle McMartin <kyle@kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	David Woodhouse <david.woodhouse@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Morris <james.l.morris@oracle.com>,
	keyrings@linux-nfs.org, Abelardo Ricart III <aricart@memnix.com>,
	"Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On May 21, 2015 8:52 AM, "David Howells" <dhowells@redhat.com> wrote:
>
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

I think PKCS#7 doesn't even solve the problem we actually need to
solve, which is that we want to trust the wireless regulatory key for
regulatory.bin but nothing else.  Keep in mind that every attempt to
do this for web CAs using X.509 has failed miserably (Google "name
constraints"), whereas having a trivial set if flags associated with
any key format whatsoever in the kernel would solve it fully.

Just track a list of allowed purposes for each key.  If we really
really need cert chains, restrict the child to be a subset of the
parent, which is something that X.509 thoroughly screwed up.

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

Famous last words: "Is probably a sufficient restriction".  Let the
crypto do its job -- the bad guys are almost certainly more clever
than the module loader.

I think that we neither can nor should check the module name against a
tag -- the module name is part of the signed module payload.

>      I don't believe that kexec signing requires a name hint either since I
>      think the only restriction on what we're allowed to kexec is that it must
>      be bootable from the beginning - and must be a PE binary on x86 type
>      platforms.
>
> I do have patches to parse PGP key data and add the public keys found therein
> onto the kernel keyring, but that would mean adding an extra key data parser.

Why would this have to live in the kernel?  If you want to add a key
to the keyring, feed the raw key to the keyring along with some reason
to trust the key.  There's no need to stick OpenPGP in the kernel.

I think we're all (except maybe Luis) too stuck on key/cert formats.
Kyle wants to use OpenPGP.  You want to use PKCS#7.  Some people want
to use PKCS#11 with whatever wrapper.  Probably someone out there
wants to use the SSH infrastructure.  Who cares?  As long as we keep
using PKCS#1 v1.5 as the underlying technology, all of these are
exactly equivalent.

Some day soon we should move away from PKCS#1 v1.5 as our preferred
technology, at which point either we still support it for legacy
purposes or we have to update the tooling.  But I really think that
the tooling should be just that: tooling.

The single reasonably exception I've heard is that we need to support
Authenticode for kexec.  I don't really believe that entirely --
surely we can produce a kernel image that is both validly signed using
Authenticode *and* validly signed with our internal format.  Or we can
have a separate special-case parser for Authenticode-signed kexec
images and we can turn it off for users who don't want it (which
presumably includes everyone using things like Quark, which is a
bizarre architecture that is extremely memory-constrained but
nonetheless supports Secure Boot).

>
> You could probably do this with the integrity functions - but turning them on
> has a performance cost and you have to load things in the right order as I
> understand it.

It's also a performance cost because the average user of this
signature stuff doesn't actually want IMA, and IMA is checking the
wrong think anyway.  IMA/EVM tells us "this file validly belongs in
/lib/modules/whatever according to whomever we trust for the
filesystem".  We want to check "is this data, regardless of where it
was read from, a trusted module".

>
> The hash list idea for firmware really isn't a starter for a distribution like
> Fedora and especially RHEL.  We would have to crank out a new set of kernels
> any time anyone released a new firmware that someone might want to load since
> the hash list is effectively dependent on *all* the firmware blobs.  Further,
> you cannot ever discard any entries as you would potentially prevent someone's
> system from booting if you did.

Can we please stop beating this dead horse?  AFAIK no one ever
suggested using a has list for firmware in the first place.

>
> > > 3. PKCS#1 v1.5, really?  PKCS#1 v1.5 is known to be insecure unless
> > > very cafefully validated.  For example:
> > >
> > > https://www.imperialviolet.org/2014/09/26/pkcs1.html
> > >
> > > Could we please consider using a signature scheme with a security proof?
> >
> > I'm fine with going with some other alternative, now what do you have in mind?
>
> We can look at moving to PKCS#1 v2.1 and using RSASSA-PSS.  The main
> difficulty is persuading openssl that it wants to do that.
>

openssl pkeyutl appears to support PSS.

> Andy Lutomirski <luto@amacapital.net> wrote:
>
> > RSA-PSS, ECDSA over P-256, or Ed25519.  The IRTF CFRG is expected to
> > publish an RFC for a modern signature scheme any day^Wmonth^Wyear now,
> > too.
>
> These are public key algorithms, not message/certificate formats, so comparing
> X.509 or PKCS#7 to ECDSA or Ed25519 is not valid.

Sure it is, because we don't actually seem to need a fancy
message/certificate format in the first place.

--Andy
