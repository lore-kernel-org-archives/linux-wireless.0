Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43865 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756730AbbEUQn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:43:26 -0400
Date: Thu, 21 May 2015 19:43:14 +0300
From: Petko Manolov <petkan@mip-labs.com>
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
	zohar@linux.vnet.ibm.com, mricon@kernel.org,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521164313.GH18164@localhost> (sfid-20150521_184409_840329_90BF1B53)
References: <20150519221128.GP23057@wotan.suse.de>
 <20150519200232.GM23057@wotan.suse.de>
 <555BA438.2070802@kernel.org>
 <9567.1432223509@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9567.1432223509@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-21 16:51:49, David Howells wrote:
> 
> I do have patches to parse PGP key data and add the public keys found therein
> onto the kernel keyring, but that would mean adding an extra key data parser.

PGP is widely used so i would gladly have one more parser in the kernel.

> You could probably do this with the integrity functions - but turning them on 
> has a performance cost and you have to load things in the right order as I 
> understand it.

The performance hit is negligible, especially on modern hardware.  The problem 
is that Joe user must wrap his head around IMA as a concept and go through the 
pains of doing everything right.  Failing to do so will result in a lot of 
frustration, and i speak from experience.

Once you make it run properly it mostly stays out of your way.  To put it 
another way: IMA is not for sissies... :)


		Petko
