Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33905 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935108AbdIZGpA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 02:45:00 -0400
Date: Mon, 25 Sep 2017 23:44:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ath9k: add a quirk to set use_msi automatically
Message-ID: <20170926064456.GA28611@infradead.org> (sfid-20170926_084541_710712_AF8A62B2)
References: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
 <1506408099-18488-2-git-send-email-acelan.kao@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506408099-18488-2-git-send-email-acelan.kao@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 02:41:35PM +0800, AceLan Kao wrote:
> Some platform(BIOS) blocks legacy interrupts (INTx), and only allows MSI
> for WLAN device. So adding a quirk to list those machines and set
> use_msi automatically.
> Adding Dell Inspiron 24-3460 to the quirk.

Huh?  Using MSI should be the default, and skipping MSI should be
a quirk if needed at all (usually it should be autodetected)
