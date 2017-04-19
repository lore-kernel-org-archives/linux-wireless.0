Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38732 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762833AbdDSMKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 08:10:39 -0400
Message-ID: <1492603836.22185.4.camel@sipsolutions.net> (sfid-20170419_141042_601717_5442A13E)
Subject: unbalanced local_bh_disable
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 19 Apr 2017 14:10:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

I'm seeing things like this with sparse:

drivers/net/wireless/intel/iwlwifi/pcie/rx.c:1746 iwl_pcie_irq_handler() warn: returning with unbalanced local_bh_disable
drivers/net/wireless/intel/iwlwifi/pcie/rx.c:1992 iwl_pcie_irq_msix_handler() warn: returning with unbalanced local_bh_disable

but the code looks like

                local_bh_disable();
                iwl_pcie_rx_handle(trans, 0);
                local_bh_enable();

Any idea what's confusing smatch?

Thanks,
johannes
