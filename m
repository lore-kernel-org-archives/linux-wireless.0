Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43948 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964804AbbEUQ7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:59:05 -0400
Date: Thu, 21 May 2015 19:58:56 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521165856.GJ18164@localhost> (sfid-20150521_185913_844545_367B93D7)
References: <20150519221128.GP23057@wotan.suse.de>
 <20150519200232.GM23057@wotan.suse.de>
 <555BA438.2070802@kernel.org>
 <9567.1432223509@warthog.procyon.org.uk>
 <20150521164313.GH18164@localhost>
 <CALCETrX=8OpsRE2adMoX8P0xYA6hCjhPwCOJJ19gX=tMOSP0PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrX=8OpsRE2adMoX8P0xYA6hCjhPwCOJJ19gX=tMOSP0PQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-21 09:48:10, Andy Lutomirski wrote:
> On Thu, May 21, 2015 at 9:43 AM, Petko Manolov <petkan@mip-labs.com> wrote:
> > On 15-05-21 16:51:49, David Howells wrote:
> >>
> >> I do have patches to parse PGP key data and add the public keys found therein
> >> onto the kernel keyring, but that would mean adding an extra key data parser.
> >
> > PGP is widely used so i would gladly have one more parser in the kernel.
> 
> <rant>
> PGP is also a crappy format:
> 
> http://blog.cryptographyengineering.com/2014/08/whats-matter-with-pgp.html
> 
> and using PGP means we're probably stuck with PKCS#1 v1.5, which should have 
> been phased out worldwide many years ago.
> 
> In any event, I don't see why PGP compatibility requires any sort of
> OpenPGP parser in the kernel.  Just because GnuPG goes out of its way
> to be incompatible with anything other than the OpenPGP ecosystem
> doesn't mean that you can't relatively straightforwardly generate raw
> PKCS#1 signatures from an OpenPGP key.
> </rant>

Oh, i do agree with you in terms of quality of both formats.  However, this is 
what is commonly used these days and not having these parsers in the kernel 
would require us to write tools for conversion to saner format.  Which does not 
exist for the moment.  Once we have those in place it would be all the same to 
me.


		Petko
