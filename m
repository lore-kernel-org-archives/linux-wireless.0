Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7332 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbcBYU4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 15:56:16 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Kalle Valo <kvalo@adurom.com> Kalle Valo" <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2016-02-25
Date: Thu, 25 Feb 2016 20:56:07 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com> (sfid-20160225_215619_442183_0939D2B0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request for 4.5 still. Two small fixes. One of them has a really visible impact when we remove stations.
Let me know if you have issues! Thanks.

The following changes since commit 20aa99bbddae74bded68338f9ba200ccae02858b:

  iwlwifi: pcie: fix erroneous return value (2016-02-15 13:38:31 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-02-25

for you to fetch changes up to 905e36ae172c83a30894a3adefab7d4f850fcf54:

  iwlwifi: mvm: Fix paging memory leak (2016-02-23 21:51:30 +0200)

----------------------------------------------------------------
Two fixes for 4.5:
* We forgot to free the paging memory (Matti)
* Fix the frames in flight accounting (Liad)

----------------------------------------------------------------
Liad Kaufman (1):
      iwlwifi: mvm: inc pending frames counter also when txing non-sta

Matti Gottlieb (1):
      iwlwifi: mvm: Fix paging memory leak

 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  | 9 +++++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

