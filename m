Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:39287 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750888AbdAMATp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 19:19:45 -0500
Date: Fri, 13 Jan 2017 11:12:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: linux-next: build warning after merge of the wireless-drivers-next
 tree
Message-ID: <20170113111250.2023a160@canb.auug.org.au> (sfid-20170113_012003_495902_ABA131D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(x86_64 allmodconfig) produced this warning:

drivers/net/wireless/marvell/mwifiex/pcie.c: In function 'mwifiex_pcie_remove':
drivers/net/wireless/marvell/mwifiex/pcie.c:303:5: warning: 'fw_status' may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (fw_status == FIRMWARE_READY_PCIE && !adapter->mfg_mode) {
     ^

Introduced by commit

  045f0c1b5e26 ("mwifiex: get rid of global user_rmmod flag")

This is not a false positive since "reg" could be NULL just above
(otherwise it would be tested for).

-- 
Cheers,
Stephen Rothwell
