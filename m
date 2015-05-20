Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34684 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbbETPsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 11:48:14 -0400
Received: by oiko83 with SMTP id o83so39284856oik.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 08:48:14 -0700 (PDT)
Date: Wed, 20 May 2015 10:47:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520154755.GE126473@ubuntu-hedt> (sfid-20150520_174834_953012_28039897)
References: <20150520140426.GB126473@ubuntu-hedt>
 <20150519200232.GM23057@wotan.suse.de>
 <6731.1432134538@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6731.1432134538@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 04:08:58PM +0100, David Howells wrote:
> Seth Forshee <seth.forshee@canonical.com> wrote:
> 
> > > This begs the question on how we'd manage keys for firmware signing on
> > > linux-firmare. Since the keys are x509 keys we need a CA. Based on some
> > > initial discussions it would seem we'd need the Linux Foundation to create
> > > a key, this would be embedded in the kernel and that key would be used to
> > > sign Kyle's key.  Kyle would in turn use his key for signing
> > > linux-firmware files. David, Kyle, did I summarize this correctly ?
> > 
> > I raised the question of key revocation when we discussed this on irc,
> > but it wasn't answered to my satisfaction. If a key signed by the
> > kernel-embedded key is compromised, how can that key be revoked so that
> > it is no longer trusted?
> > 
> > Someone mentioned UEFI blacklists, which I don't know much about, but
> > not all systems have UEFI. The only reliable option that comes to mind
> > for me is an in-kernel blacklist of keys which should no longer be
> > trusted.
> 
> Key revocation is generally an unpleasant problem.  How do you inform a system
> that a key of any sort is revoked?  With PGP, for instance, you might be able
> to connect to the net and consult a server.

Distros could distribute updates to the blacklist via their usual update
mechanisms. That could be a new kernel with an updated blacklist (after
all we should expect blacklist updates to be very infrequent).

I suppose a database in the initrd which was loaded prior to loading any
firmware could work too, then perhaps new blacklists could be loaded
into a running kernel without a reboot as well. But that database should
probably be signed too, which creates a chicken-and-egg sort of problem.

> UEFI has a blacklist that can theoretically be used to prevent both usage of a
> key and usage of a particular object.  As I understand it, the blacklist in
> UEFI is just a table of SHA256 hashes.
> 
> Relying on UEFI presents three problems, though: (1) the system admin has to
> manually, as far as I'm aware, inform the BIOS; (2) the UEFI storage is
> limited; and (3) not all systems have UEFI.

Yeah, that doesn't really sound like a good solution. Not all users are
sys admins.

> What you do on a non-UEFI system, I'm not sure.  If the kernel isn't verified
> by the loader or the system firmware then you don't have a 'fully' secure
> system anyway and the blacklist may be of questionable value.

I think there's still value - compromised firmware could easily be a
vector to compromise the kernel. Just because I can't verify my system
security doesn't mean that I don't want measures in place to keep it
from being compromised.

Seth
