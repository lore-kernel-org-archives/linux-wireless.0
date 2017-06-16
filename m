Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41669 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750792AbdFPD5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:57:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 0/4] neard: Add support for deactivating tags
Date: Thu, 15 Jun 2017 20:57:24 -0700
Message-Id: <20170616035728.19415-1-mgreer@animalcreek.com> (sfid-20170616_055743_984633_DE410B08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the ability for client apps to deactivate a currently
active tag.  Once deactivated, the client can either poll again to
reactivate the tag or power the adapter off to save power.  These
changes will not work until the Linux kernel commits submitted under
the subject, "NFC: Add deactivate target functionality" are committed.
Those commits can be viewed here:

	https://lists.01.org/pipermail/linux-nfc/2017-June/004415.html

The commits are based on the commits submitted previously under the
subject, "[PATCH 00/23] neard: Support TI Std & Pro tags, fixups, etc."
which can be viewed here:

	https://lists.01.org/pipermail/linux-nfc/2017-June/004392.html

For convenience, these commits are available in the 'submit/deactivate_tag-v1'
branch of this repo on github:

	https://github.com/animalcreek/neard.git

Mark Greer (4):
  adapter: Make adapter_start_poll() global
  adapter: Add call indicating whether constant poll is enabled
  tag: Add Tag deactivate support
  test: Add option to deactivate tag

 doc/tag-api.txt    |  8 ++++++++
 include/nfc_copy.h |  2 ++
 src/adapter.c      | 27 ++++++++++++++++-----------
 src/near.h         |  3 +++
 src/netlink.c      | 33 +++++++++++++++++++++++++++++++++
 src/tag.c          | 29 +++++++++++++++++++++++++++++
 test/test-tag      | 13 +++++++++++++
 7 files changed, 104 insertions(+), 11 deletions(-)

-- 
2.13.0
