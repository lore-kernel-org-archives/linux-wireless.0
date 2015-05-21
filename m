Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54393 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422691AbbEUQ7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:59:40 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 21 May 2015 22:29:38 +0530
Message-ID: <1432227565.2450.23.camel@linux.vnet.ibm.com> (sfid-20150521_185954_229817_49CBB836)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Petko Manolov <petkan@mip-labs.com>
Cc: David Howells <dhowells@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
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
Date: Thu, 21 May 2015 12:59:25 -0400
In-Reply-To: <20150521164313.GH18164@localhost>
References: <20150519221128.GP23057@wotan.suse.de>
	 <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
	 <9567.1432223509@warthog.procyon.org.uk> <20150521164313.GH18164@localhost>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-21 at 19:43 +0300, Petko Manolov wrote:
> On 15-05-21 16:51:49, David Howells wrote:
> > 
> > I do have patches to parse PGP key data and add the public keys found therein
> > onto the kernel keyring, but that would mean adding an extra key data parser.
> 
> PGP is widely used so i would gladly have one more parser in the kernel.
> 
> > You could probably do this with the integrity functions - but turning them on 
> > has a performance cost and you have to load things in the right order as I 
> > understand it.
> 
> The performance hit is negligible, especially on modern hardware.  The problem 
> is that Joe user must wrap his head around IMA as a concept and go through the 
> pains of doing everything right.  Failing to do so will result in a lot of 
> frustration, and i speak from experience.
> 
> Once you make it run properly it mostly stays out of your way.  To put it 
> another way: IMA is not for sissies... :)

The main problem today is that software doesn't come and isn't installed
with file signatures.   Once file signatures are installed with the
files,  then it is just a matter of the machine owner signing the
software's public keys.   Dracut (or equivalent) would load the signed
keys onto the trusted IMA keyring.

Mimi

