Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38493 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbbESU7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 16:59:41 -0400
Message-ID: <555BA438.2070802@kernel.org> (sfid-20150519_225958_906279_24A61BDD)
Date: Tue, 19 May 2015 13:59:36 -0700
From: Andy Lutomirski <luto@kernel.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Rusty Russell <rusty@rustcorp.com.au>,
	LSM List <linux-security-module@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
References: <20150519200232.GM23057@wotan.suse.de>
In-Reply-To: <20150519200232.GM23057@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[added cc's from the other thread]

On 05/19/2015 01:02 PM, Luis R. Rodriguez wrote:
> David Howells has posted v4 of his series of supporting PKCS#7 for module
> signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
> some review and patch shuffling I think this is ready for patch form.  My own
> series however depend on quite a bit of other pending changes, one series which
> will go through Rusty's tree, another series of fixes on firmware_class which
> should go through Greg's tree. I'll wait until all this and David's own patches
> get merged before posting firmware PKCS#7 support. Before all this though in
> preparation for fw signing one thing we should start to talk about more broadly
> however is how linux-firmware binary file signing would work in practice and
> what we need, and make sure folks are OK with all this.
>
> First, firmware signing will be completely optional as with module signing.
>

...

> Other than this last nitpick, any other concerns or recommendations ?

A couple.  Some of these are general concerns with the existing 
infrastructure, but #1 is a specific problem that gets much worse if we 
add firmware signing.  Feel free to ignore 2-4.

1. We should get the signature semantics right.  I think that, for 
modules, we currently sign literally the module payload.  For modules, 
in my semi-amateurish crypto universe [1], this is fine *as long as the 
key in question is used for no other purpose*.  For firmware, it's 
dangerous, since it would be vulnerable to substitution attacks in which 
the adversary convinces us to interpret one firmware file as firmware 
for another device or purpose entirely.

We should be signing something that's semantically equivalent to "This 
is a valid module: xyz", "This is a valid 'regulatory.bin': xyz", or 
"This is a valid kexec image: xyz".

2. Why on earth does the magic signing script reference things like 
commonName?  Please keep X.509 silliness as far from the kernel as possible.

3. PKCS#1 v1.5, really?  PKCS#1 v1.5 is known to be insecure unless very 
cafefully validated.  For example:

https://www.imperialviolet.org/2014/09/26/pkcs1.html

Could we please consider using a signature scheme with a security proof?

4. As hashed to death in another thread:

http://lkml.kernel.org/g/555A88FB.7000809@kernel.org

I think that the verifier should be a dynamically loadable thing.  For 
an initial firmware signature verification scheme, I think that using 
digital signatures is fine, though

[1] I'm sometimes a bona fide quantum cryptographer, but I'm at best a 
reasonably clueful classical cryptographer wannabe.

--Andy
