Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34499 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbbEUQsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:48:32 -0400
Received: by laat2 with SMTP id t2so106963996laa.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 09:48:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150521164313.GH18164@localhost>
References: <20150519221128.GP23057@wotan.suse.de> <20150519200232.GM23057@wotan.suse.de>
 <555BA438.2070802@kernel.org> <9567.1432223509@warthog.procyon.org.uk> <20150521164313.GH18164@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 May 2015 09:48:10 -0700
Message-ID: <CALCETrX=8OpsRE2adMoX8P0xYA6hCjhPwCOJJ19gX=tMOSP0PQ@mail.gmail.com> (sfid-20150521_184836_385446_D0000B51)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: David Howells <dhowells@redhat.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 9:43 AM, Petko Manolov <petkan@mip-labs.com> wrote:
> On 15-05-21 16:51:49, David Howells wrote:
>>
>> I do have patches to parse PGP key data and add the public keys found therein
>> onto the kernel keyring, but that would mean adding an extra key data parser.
>
> PGP is widely used so i would gladly have one more parser in the kernel.

<rant>
PGP is also a crappy format:

http://blog.cryptographyengineering.com/2014/08/whats-matter-with-pgp.html

and using PGP means we're probably stuck with PKCS#1 v1.5, which
should have been phased out worldwide many years ago.

In any event, I don't see why PGP compatibility requires any sort of
OpenPGP parser in the kernel.  Just because GnuPG goes out of its way
to be incompatible with anything other than the OpenPGP ecosystem
doesn't mean that you can't relatively straightforwardly generate raw
PKCS#1 signatures from an OpenPGP key.
</rant>
