Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36329 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbbESAri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 20:47:38 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com
Cc: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
	dhowells@redhat.com, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v3 0/2] firmware: add PKCS#7 firmware signature support
Date: Mon, 18 May 2015 17:45:23 -0700
Message-Id: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150519_024756_994698_211EC050)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is the third iteration of RFCs for firmware signature suppport.
Upon review through discussions on the threads and IRC it seems folks are
generally OK with this now. This is rebased on top of David's latest pkcs7
branch but also depends on a series of patches which Rusty has said he
already applied but not yet visible on linux-next. It also has a series of
fixes posted by not yet in any tree nor has anyone claimed. Since the delta
is quite big in order to help folks review and test I've put up a branch
with all pending patches and requirements merged, you should use the
fw-signing-v3-20150518 branch on this tree:

https://git.kernel.org/cgit/linux/kernel/git/mcgrof/linux.git/

This is based on Linus' tree as base.

Changes on this v3 since the last v2 series:

  * Updated to David's latest pkcs7 branch
  * Dropped patches based on the above re-work
  * Avoid recommending use of scripts/sign-file to sign
    firmware as openssl can be used directly
  * Change expected file extension to be foo.bin.p7s, and
    update documentation to reflect this and how folks
    can let the kernel trust a key for fw signing.
  * Drop crypto qat work arounds - no longer needed

Luis R. Rodriguez (2):
  firmware: generalize reading file contents as a helper
  firmware: add firmware signature checking support

 Documentation/firmware_class/signing.txt |  90 ++++++++++++
 drivers/base/Kconfig                     |  18 +++
 drivers/base/firmware_class.c            | 236 +++++++++++++++++++++++++++++--
 3 files changed, 334 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/firmware_class/signing.txt

-- 
2.3.2.209.gd67f9d5.dirty

