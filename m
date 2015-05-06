Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34844 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbbEFAqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 20:46:42 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 00/12] kernel/firmware/wireless: firmware digital signature checks
Date: Tue,  5 May 2015 17:44:18 -0700
Message-Id: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_024704_758776_44166AA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We've been discussing for a while now replacing the 802.11 Linux
CRDA agent [0] by in-kernel functionality. This series address
what is required to begin to take this serious. It is split by
a few series of patches, I've linked them all as otherwise folks
might get confused. I clarify what is what below and by a prefix
on each patch.

  * first set: [1-4] few fixes and core changes in order to consider digital
    firmware signature support. Please consider these for integration. Patch
    2 generalizes module signing as system data signing and can very likely
    just be ignored unles the second set seems more reasonable to start
    considering. One of these goes as a stable fix.

  * second set: [5-6] kernel firmware signature support. These should be
    considered for discussion. We need to figure out what if/how we want
    to deal with this. Its obviously needed to replace userspace agents
    with similar requirements, so its a requirement for the last set.

  * third set: [7-12] firmware API simplication / extensibility rewrite,
    more for discussion than anything as we keep extending it, then it
    starts piggy backing alternative crypto requirements. Its intended to
    provide as an example how subsystems might differ in their requirements
    for files in userspace. The driver changes should be completely ignored
    as real patches -- these are just example patches of *how* to use the
    APIs. The cfg80211 change should be reviewed as its how we could
    end up providing optional alternative cyrpto requirements and extensions,
    should we go down that road.

I did consider LSM hooks -- but since we already have one for firmware
and since this re-uses the firmware API, the same LSM hooks can be used
for distributions that want that over digital signature verification
of speficic firmware / system data files.

My own preference and recommendations:

This has served more as an excercise to review the firmware module code
and to get us to more seriously consider whether or not we want
digital firmware signature checks. I think we should seriously
consider replacing the custom CRDA key option with kernel distribution 
private / public keys used for module signing, and for further
customization simply let folks use LSM hooks / LSM modules for
customization as well as the Integrity Measurement Architecture (IMA) [1].

We *should* seriously consider digital firmware signature support,
how we want to phase usermode helper suppport and how we want to
enable extensions of the firmware API as the current code isn't
practical for extensions/growth. In so far a digital firmware
signature support I think it might be a good idea to support different
files for signatures and request those in addition to the actual
firmware, any reason not to do it that way?

Please note that the binary firmware format still needs to be
addresed. I don't have time for that though so I hope that this
will help suffice to at least address the requirements to replace
CRDA in-kernel.

[0] https://wireless.wiki.kernel.org/en/developers/regulatory/crda
[1] http://sourceforge.net/p/linux-ima/wiki/Home/

Luis R. Rodriguez (12):
  1  - kernel/params.c: export param_ops_bool_enable_only
  2  - kernel: generalize module signing as system data signing
  3  - crypto: qat - address recursive dependency when fw signing is enabled
  4  - firmware: fix possible use after free on name on asynchronous request

  5  - firmware: add firmware signature checking support
  6  - firmware: generalize "firmware" as "system data" helpers

  7  - firmware: add generic system data helpers with signature support
  8  - p54spi: use sysdata_file_request() for EEPROM optional system data
  9  - p54: use sysdata_file_request() and sysdata_file_request_async()
  10 - ath9k_htc: use sysdata_file_request() and sysdata_file_request_async()
  11 - iwlwifi: use sysdata_file_request() and sysdata_file_request_async()
  12 - cfg80211: request for regulatory system data file

 drivers/base/Kconfig                           |  16 ++
 drivers/base/firmware_class.c                  | 318 ++++++++++++++++++++++++-
 drivers/crypto/qat/Kconfig                     |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c       |  62 +++--
 drivers/net/wireless/iwlwifi/iwl-drv.c         |  24 +-
 drivers/net/wireless/p54/eeprom.c              |   1 -
 drivers/net/wireless/p54/fwio.c                |   4 +-
 drivers/net/wireless/p54/led.c                 |   1 -
 drivers/net/wireless/p54/main.c                |   1 -
 drivers/net/wireless/p54/p54.h                 |   4 +-
 drivers/net/wireless/p54/p54pci.c              |  19 +-
 drivers/net/wireless/p54/p54pci.h              |   2 +-
 drivers/net/wireless/p54/p54spi.c              |  68 +++---
 drivers/net/wireless/p54/p54spi.h              |   2 +-
 drivers/net/wireless/p54/p54usb.c              |  14 +-
 drivers/net/wireless/p54/p54usb.h              |   2 +-
 drivers/net/wireless/p54/txrx.c                |   1 -
 include/linux/firmware.h                       |   1 +
 include/linux/sysdata.h                        | 200 ++++++++++++++++
 init/Kconfig                                   |  22 +-
 kernel/Makefile                                |   2 +-
 kernel/module-internal.h                       |  12 -
 kernel/module.c                                |   4 +-
 kernel/params.c                                |   1 +
 kernel/{module_signing.c => sysdata_signing.c} |  77 +++---
 kernel/system_keyring.c                        |   2 +-
 net/wireless/Kconfig                           |  20 ++
 net/wireless/reg.c                             |  85 +++++--
 scripts/sign-file                              |  20 +-
 29 files changed, 804 insertions(+), 183 deletions(-)
 create mode 100644 include/linux/sysdata.h
 delete mode 100644 kernel/module-internal.h
 rename kernel/{module_signing.c => sysdata_signing.c} (76%)

-- 
2.3.2.209.gd67f9d5.dirty

