Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60828 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934953AbdIZH0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 03:26:54 -0400
Received: from mail-wm0-f72.google.com ([74.125.82.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1dwkGb-0001yY-89
        for linux-wireless@vger.kernel.org; Tue, 26 Sep 2017 07:26:53 +0000
Received: by mail-wm0-f72.google.com with SMTP id e64so10994097wmi.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2017 00:26:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170926064456.GA28611@infradead.org>
References: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
 <1506408099-18488-2-git-send-email-acelan.kao@canonical.com> <20170926064456.GA28611@infradead.org>
From: AceLan Kao <acelan.kao@canonical.com>
Date: Tue, 26 Sep 2017 15:26:51 +0800
Message-ID: <CAFv23Qm9kZLSqJ_BP1D7mWCxekq0nt3S8onT1ckH-AoHDBUDzw@mail.gmail.com> (sfid-20170926_092739_200089_64E2B00B)
Subject: Re: [PATCH 2/6] ath9k: add a quirk to set use_msi automatically
To: Christoph Hellwig <hch@infradead.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath9k is an old driver for old chips, and they work fine with legacy INTx.
But some new platforms are using it, so I think we should list those
new platforms which blocks INTx in the driver.

BTW, new chips use ath10k driver.

2017-09-26 14:44 GMT+08:00 Christoph Hellwig <hch@infradead.org>:
> On Tue, Sep 26, 2017 at 02:41:35PM +0800, AceLan Kao wrote:
>> Some platform(BIOS) blocks legacy interrupts (INTx), and only allows MSI
>> for WLAN device. So adding a quirk to list those machines and set
>> use_msi automatically.
>> Adding Dell Inspiron 24-3460 to the quirk.
>
> Huh?  Using MSI should be the default, and skipping MSI should be
> a quirk if needed at all (usually it should be autodetected)
