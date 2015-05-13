Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36036 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbEMS0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:26:09 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 0/6] firmware: add PKCS#7 firmware signature support
Date: Wed, 13 May 2015 11:23:50 -0700
Message-Id: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_202615_107206_33FA62FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Upon review of the v1 series David Howells requested I re-work
the code on top of his PKCS#7 branch [1] which moves module signing
to support and use PKCS#7. This v2 series is based on top of that
branch. Other than David's own changes this series depends on some
other changes Rusty has taken in already but not yet visible on
linux-next:

kernel/params: constify struct kernel_param_ops uses
kernel/module.c: use generic module param operaters for sig_enforce
kernel/params.c: generalize bool_enable_only
moduleparam.h: add module_param_config_*() helpers
kernel/workqueue.c: remove ifdefs over wq_power_efficient
kernel/workqueue.c: use module_param_config_on_off() for power_efficient
kernel/module.c: avoid ifdefs for sig_enforce declaration
kernel/params.c: export param_ops_bool_enable_only

This series also depends on the fixes recently posted for the firmware_class
driver:

firmware: fix __getname() missing failure check
firmware: check for file truncation on direct firmware loading
firmware: fix possible use after free on name on asynchronous request
firmware: use const for remaining firmware names

Since that is quite a bit of delta, if folks want to help test / review
this on a tree, you can use this tree with the fw-signing-v2-20150513
branch:

https://git.kernel.org/cgit/linux/kernel/git/mcgrof/linux.git/

This v2 modifies the way we do firmware signature checking from the v1 RFCs by
using separate detached files for the signatures of the firmware files, as
suggested by David. If you have foo.bin, you'll need foo.bin.pkcs7 present
when firmware signature checks are enabled.

Since it is based on David's modsign-pkcs7 branch and since these
are not yet upstream I think its best if David took what he can as part of his
series and squashed commits when and where possible. For instance the
sign-file.c changes can likely be squashed. Patch 2, which generalizes module
signing as system data signing is based on David's own series, in my previous
series I addressed code in place upstream which lacked PKCS#7 support, I'll
leave it up to David to decide if / when to merge this into his series but
I think that if this is reasonable it can go in prior to addition of
PKCS#7 support, in which case my v1 patch can be used. Otherwise this v2
will need to be used. Also, patch 2 in this v2 series changes the config
SYSDATA_SIG to def_bool n as noted by Paul Bolle.

Patch 3 simply has the commit log massaged to account for the discussions
on the recursive issue it tries to fix. Based on discussions the recursive
issue reported by the code is real [2], however since FW_LOADER is an EXPERT
option it is reasonable to make this change anyway. A change for now seems
reasonable.

Lastly, we'll need to export data_verify_pkcs7() as we are dealing with
a split between that data and signature. The last patch adds firmware
signature support. I like to think it works as expected, with a simple
requirement to have you sign-file -s the binaries. As with module signing
there are 3 modes of operation with firmware signature support:

  a) signature disabled
  b) signature enabled - but permissive - we'll let things slide if not signed
  c) signature enforced - firmware not signed will not be allowed

In the permissive case though the only difference from the module
signing code / logic is that we *do not* taint the kernel. The reason
for this is technical. First of all add_taint_module() is not exported,
are we OK to export it? If not what users do we wish to grant access to
it? If we wish to provide a mechanism by which we can have a say in that
the old module namespace work by Andi Kleen comes to mind as useful for
that [3]. If we're OK with wide access to add_taint_kernel() as an exported
symbol there are yet other technical questions to address, add_taint_kernel()
requires a module passed and only *one* of the 3 request_firmware*() APIs peg
the correct module caller of the API onto firmware_class, the others use the
firmware_class struct module.

We have a few options then:

  1) Extend the firmware_class driver API to require the correct module to
     always be set. Doing this IMHO is worthy, but its not just worthy for
     firmware signing tainting, it may come in handy in the future. There's
     an issue with extending the firmware_class APIs though which make me
     nervous about just doing this change even if we wanted this alone for
     firmware signature checks -- the firmware_class APIs keep being extended
     requiring collateral evolutions which IMHO can be avoided if we sat and
     thought about a decent API which can be grown for our requirements.

  2) Use add_taint_module() with the firmware_class module for the two
     synchrounous APIs, while using the right module for the async call.

  3) Use the firmware_class module for all 3 API calls when using
     add_taint_module()

  4) Skip tainting the kernel for unsigned firmware files

The approach I've decided to take here is a combination of 4) and 1). I've
decided that extending the firmware_class API even more is not a good idea
anymore. Part of this is because I have some other uses cases for
firmware_class's use and having the right module is not the only thing I'd
want to extend firmware_class with support for. I address a spring cleaning
of the firmware_class API in my next series, while also enabling passing
the right module always, and enabling use of tainting. I think its best to
leave the old APIs as-is then, and only if folks really require a shift to
taint they can then consider the new APIs. If we *really* want to taint the
kernel even for the old APIs I recommend just dealing with using the
firmware_class (THIS_MODULE) for now -- I don't think making the taint
specific to a module for firmware is worth the collateral evolutions required
using and extending the old APIs.

The new extensible firmware_class APIs go in my next series, that enables
tainting the specific caller module, among other things, as you'll see.

[0] https://lkml.org/lkml/2015/5/5/1345
[1] http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7
[2] https://lkml.org/lkml/2015/5/5/1353
[3] https://backports.wiki.kernel.org/index.php/Documentation/backports/hacking/todo#Module_namespaces

Luis R. Rodriguez (6):
  firmware: generalize reading file contents as a helper
  kernel: generalize module signing as system data signing
  crypto: qat - address recursive dependency when fw signing is enabled
  scripts/sign-file.c: add support to only create signature file
  kernel/sysdata_signing: export data_verify_pkcs7()
  firmware: add firmware signature checking support

 Documentation/firmware_class/signing.txt           |  88 ++++++++
 drivers/base/Kconfig                               |  18 ++
 drivers/base/firmware_class.c                      | 237 ++++++++++++++++++++-
 drivers/crypto/qat/Kconfig                         |   2 +-
 .../module-internal.h => include/linux/sysdata.h   |   6 +-
 init/Kconfig                                       |  24 ++-
 kernel/Makefile                                    |   2 +-
 kernel/module.c                                    |   4 +-
 kernel/{module_signing.c => sysdata_signing.c}     |  60 +++---
 kernel/system_keyring.c                            |   2 +-
 scripts/sign-file.c                                |  17 +-
 11 files changed, 399 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/firmware_class/signing.txt
 rename kernel/module-internal.h => include/linux/sysdata.h (64%)
 rename kernel/{module_signing.c => sysdata_signing.c} (63%)

-- 
2.3.2.209.gd67f9d5.dirty

