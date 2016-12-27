Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbcL0JVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 04:21:49 -0500
Date: Tue, 27 Dec 2016 17:17:07 +0800
From: Peter Xu <peterx@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Intel Wireless 7260 failed to work
Message-ID: <20161227091706.GA20895@pxdev.xzpeter.org> (sfid-20161227_102204_794836_E025197E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
with my wireless card, which is:

  Intel Corporation Wireless 7260 (rev bb)

Boot message shows that no suitable firmware found:

    # journalctl -kp3
    Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
    Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
    Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
    Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
    Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
    Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!

Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
further tests have been done yet.

Is this a known issue? Please let me know if anyone wants more info or
logs, since this error triggers easily (everytime I boot).

Thanks,

-- peterx
