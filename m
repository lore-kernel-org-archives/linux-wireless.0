Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbbETPJG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 11:09:06 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150520140426.GB126473@ubuntu-hedt>
References: <20150520140426.GB126473@ubuntu-hedt> <20150519200232.GM23057@wotan.suse.de>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: dhowells@redhat.com, "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 20 May 2015 16:08:58 +0100
Message-ID: <6731.1432134538@warthog.procyon.org.uk> (sfid-20150520_170948_440924_6C2714FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth Forshee <seth.forshee@canonical.com> wrote:

> > This begs the question on how we'd manage keys for firmware signing on
> > linux-firmare. Since the keys are x509 keys we need a CA. Based on some
> > initial discussions it would seem we'd need the Linux Foundation to create
> > a key, this would be embedded in the kernel and that key would be used to
> > sign Kyle's key.  Kyle would in turn use his key for signing
> > linux-firmware files. David, Kyle, did I summarize this correctly ?
> 
> I raised the question of key revocation when we discussed this on irc,
> but it wasn't answered to my satisfaction. If a key signed by the
> kernel-embedded key is compromised, how can that key be revoked so that
> it is no longer trusted?
> 
> Someone mentioned UEFI blacklists, which I don't know much about, but
> not all systems have UEFI. The only reliable option that comes to mind
> for me is an in-kernel blacklist of keys which should no longer be
> trusted.

Key revocation is generally an unpleasant problem.  How do you inform a system
that a key of any sort is revoked?  With PGP, for instance, you might be able
to connect to the net and consult a server.

UEFI has a blacklist that can theoretically be used to prevent both usage of a
key and usage of a particular object.  As I understand it, the blacklist in
UEFI is just a table of SHA256 hashes.

Relying on UEFI presents three problems, though: (1) the system admin has to
manually, as far as I'm aware, inform the BIOS; (2) the UEFI storage is
limited; and (3) not all systems have UEFI.

What you do on a non-UEFI system, I'm not sure.  If the kernel isn't verified
by the loader or the system firmware then you don't have a 'fully' secure
system anyway and the blacklist may be of questionable value.

David
