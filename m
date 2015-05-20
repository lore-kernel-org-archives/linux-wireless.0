Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbbETPsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 11:48:55 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150519200232.GM23057@wotan.suse.de>
References: <20150519200232.GM23057@wotan.suse.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	james.l.morris@oracle.com, serge@hallyn.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 20 May 2015 16:14:19 +0100
Message-ID: <6810.1432134859@warthog.procyon.org.uk> (sfid-20150520_174946_644221_00481805)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@suse.com> wrote:

> This begs the question on how we'd manage keys for firmware signing on
> linux-firmare. Since the keys are x509 keys we need a CA. Based on some
> initial discussions it would seem we'd need the Linux Foundation to create a
> key, this would be embedded in the kernel and that key would be used to sign
> Kyle's key.  Kyle would in turn use his key for signing linux-firmware
> files. David, Kyle, did I summarize this correctly ?

Yes.

> I think we need one change here, we'd need to ensure that such key could
> only be used for vetting firmware files, not modules loaded.  The
> firmware_class could for instance still use all the keys in
> system_trusted_keyring, which would include the UEFI key db, but it does not
> seems reasonable to expect keys used for fw signing to also go into
> system_trusted_keyring to also be used for module signing.

X.509 certificates can take attributes that define what the key held therein
may be used for.

You actually have four categories of key usage, I think:

 (1) Signing modules.

 (2) Signing firmware.

 (3) Signing kernel binaries for kexec.

 (4) Signing other keys that can then be chained to (1) - (3).

For instance, the LF might use their key to sign Kyle's key.  Kyle might want
to replace his key yearly, say, because the more examples of things signed
with it, the more exposed it becomes.  So the kernel would need to carry the
LF key, say, and then the appropriate one of Kyle's keys could be loaded
dynamically.

David
