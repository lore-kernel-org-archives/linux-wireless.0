Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753372AbdBVCJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 21:09:48 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com
Cc: ming.lei@canonical.com, zajec5@gmail.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 0/2] iwlwifi: corner case fix and request module changes
Date: Tue, 21 Feb 2017 18:09:37 -0800
Message-Id: <20170222020939.28140-1-mcgrof@kernel.org> (sfid-20170222_030953_126792_735AD05E)
In-Reply-To: <20170222001822.GE31264@wotan.suse.de>
References: <20170222001822.GE31264@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v2 addresses the preference to keep things simple on iwlwifi when
requesting modules and not implementing a verifier for loaing the opmode
module. We now know what a verifier looks like for both sync and async
approaches. The already established long standing practice of just doing
best effort to load suffices and keeps the driver cleaner.

There no change to the first patch. The second patch just embraces
request_module_nowait() instead of implementing a verifier for a sync
call. The remaining patches from the last series will be sent separately.

Luis R. Rodriguez (2):
  iwlwifi: fix drv cleanup on opmode registration failure
  iwlwifi: simplify requesting ops module

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

-- 
2.11.0
