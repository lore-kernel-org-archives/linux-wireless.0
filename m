Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43911 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756275AbbEUQvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:51:14 -0400
Date: Thu, 21 May 2015 19:51:02 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, Joey Lee <jlee@suse.de>,
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
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521165101.GI18164@localhost> (sfid-20150521_185126_291461_C58EFFE6)
References: <20150519200232.GM23057@wotan.suse.de>
 <555BA438.2070802@kernel.org>
 <20150519221128.GP23057@wotan.suse.de>
 <9567.1432223509@warthog.procyon.org.uk>
 <CALCETrX3krCsqCLvLYx1QdnjFK=R8FF7ta=vozDcGYSTUHvSrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrX3krCsqCLvLYx1QdnjFK=R8FF7ta=vozDcGYSTUHvSrA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-21 09:39:50, Andy Lutomirski wrote:
> 
> It's also a performance cost because the average user of this signature stuff 
> doesn't actually want IMA, and IMA is checking the wrong think anyway.  
> IMA/EVM tells us "this file validly belongs in /lib/modules/whatever according 
> to whomever we trust for the filesystem".  We want to check "is this data, 
> regardless of where it was read from, a trusted module".

IMA-appraise does not care where the file comes from (although it may be 
persuaded to) and verifies file's data and meta-data against a signature.  I 
guess you should actually read the code. :)


		Petko
