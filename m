Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:42830 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095AbbETQJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 12:09:07 -0400
Date: Wed, 20 May 2015 19:08:40 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>, serge@hallyn.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520160840.GB10473@localhost> (sfid-20150520_180957_691923_9EEEE4CF)
References: <20150519200232.GM23057@wotan.suse.de>
 <1432072117.4510.180.camel@linux.vnet.ibm.com>
 <20150519221902.GQ23057@wotan.suse.de>
 <1432078625.4510.207.camel@linux.vnet.ibm.com>
 <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-19 17:22:59, Luis R. Rodriguez wrote:
>
> I have a series of reasons find IMA unsuitable for the current goals at hand:
> 
>   1) IMA is a pretty big kitchen sink, we want this to work well for
> even embedded systems, or architectures that do not have or require
> TPMs

No, it isn't.  I've profiled it and performance hit is negligible.  All hash 
algorithms used have been optimized for most cpu architectures.

>   2) The appraisal is also done for to account for a specific state of
> affairs, you appraise to the user of the integrity of the system at a
> specific point in time, firmware signing can provide integrity /
> authorship vetting of files directly from the authors. In the case of
> regulatory.bin that was the whole point of it, and firmware signing as
> is being provided is intended to generalize that but by sharing code
> in-kernel with module signing infrastructure

This is weird English to me, but since i am no native speaker either i'll blame 
myself. :)  Could you please rephrase?

> If we go with IMA, I however do not think this would be appropriate and 
> overkill at this point in time.

Depends on what your needs are.  If you need authenticity then IMA-appraise is 
definitely your way to go.  For anything less secure you may go with LSM of 
choice to apply whatever policy you may have in mind.

Again, security and convenience do not play well together.


		Petko
