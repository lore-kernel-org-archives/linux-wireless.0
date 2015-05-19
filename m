Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbbESUCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 16:02:35 -0400
Date: Tue, 19 May 2015 22:02:32 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150519200232.GM23057@wotan.suse.de> (sfid-20150519_220252_898025_A6FA46CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Howells has posted v4 of his series of supporting PKCS#7 for module
signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
some review and patch shuffling I think this is ready for patch form.  My own
series however depend on quite a bit of other pending changes, one series which
will go through Rusty's tree, another series of fixes on firmware_class which
should go through Greg's tree. I'll wait until all this and David's own patches
get merged before posting firmware PKCS#7 support. Before all this though in
preparation for fw signing one thing we should start to talk about more broadly
however is how linux-firmware binary file signing would work in practice and
what we need, and make sure folks are OK with all this.

First, firmware signing will be completely optional as with module signing.

Second, it is important to understand that part of the motivation for firmware
signing comes from the fact that since the kernel already has signature
verification support for modules and that since some subsystems have *their own
solution* for cryptographic file signing checks before feeding data to the
kernel, and their own file redistribution mechanisms in place for signed files
we can simply do away with these custom subsystem solutions by just having
firmware signing capability support and using linux-firmware as a vehicle for
subsystem file redistribution. In our particular case on the 802.11 front we
have the 802.11 regulatory database regulatoy.bin that a udev helper CRDA [0]
reads before passing a regulatory domain to the kernel.  Distributions opt in
or out of having the digital signatures on the file but we recommend it
enabled, historically this was done to help enable corporate support on the
development of 802.11 drivers upstream to address regulatory considerations,
while enabling the flexibility for folks to ignore and do what they still want.
The kernel also has the ability to support bundling in firmware as built-in,
that can also help replace our own built-in reglutory db support which is
currently fragile due to it relying on some scripts for file conversion.

So for 802.11 then we have a use case where some distribution have opted in to
file signing verification support with its own mechanisms prior to the kernel
having any firmware signing support. This means that if wish to replace the
old CRDA / wireless-regdb signed redistribution mechanism we need to also
allow subsystems to opt-in to file signature requirements, so for instance
even if a kernel would not enable firmware signing in enforced mode (requiring
a valid signature otherwise not allowing the file to be passed to the kernel)
we need to allow the 802.11 subsystem to let distributions opt-in to the
same old signature requirements as before. In order to allow this flexibility
we first need kernel firmware signing support with both permissive and
enforced mode. Later we'd need to extend the firmware_class API to pass on
requirements for signatures, to enable callers to change from permissive
to enforced mode. The later aspect of this can only be added once the kernel
has signature verification support but it does mean we needed to consider how
we'd replace the signing of the regulatory.bin file and its own redistribution
mechanisms. Today Seth Forshee maintains wireless-regdb, once the db.txt ASCII
db changes Seth ends up generating a new regulatory.bin and distributions can
pick these up. Regulatory changes are not frequent.

We have discussed how we'd replace the 802.11 subsystem own regulatory.bin
redistribution and signing mechanism and decided that if the kernel gets
firmware signing support Kyle would just sign linux-firmware files within
linux-firmware itself, and Seth would send Kyle updates to the regulatory.bin
file. Distributions that would need either regulatory.bin signed and replace
CRDA can just trust Kyle's key later, and enable the option on cfg80211 to use
the firmware_class API to request the signed file. Distributions that do this
would in turn still be able to not have firmware signature enforced for all
files, they'd just have it enabled for cfg80211, in order to replace the old
CRDA / wireless-regdb signature practice.

This begs the question on how we'd manage keys for firmware signing on
linux-firmare. Since the keys are x509 keys we need a CA. Based on some initial
discussions it would seem we'd need the Linux Foundation to create a key, this
would be embedded in the kernel and that key would be used to sign Kyle's key.
Kyle would in turn use his key for signing linux-firmware files. David, Kyle,
did I summarize this correctly ?

I think we need one change here, we'd need to ensure that such key could only
be used for vetting firmware files, not modules loaded.  The firmware_class
could for instance still use all the keys in system_trusted_keyring, which
would include the UEFI key db, but it does not seems reasonable to expect keys
used for fw signing to also go into system_trusted_keyring to also be used for
module signing.

Other than this last nitpick, any other concerns or recommendations ?

[0] https://wireless.wiki.kernel.org/en/developers/regulatory/crda

  Luis
