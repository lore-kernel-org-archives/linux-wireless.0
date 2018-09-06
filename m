Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbeIFPSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 11:18:43 -0400
Date: Thu, 6 Sep 2018 12:43:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
Message-ID: <20180906104348.GE16539@redhat.com> (sfid-20180906_124355_342779_23ED6C48)
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
 <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 06, 2018 at 11:33:55AM +0200, Felix Fietkau wrote:
> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> > Move some irq handling code to generic mmio module.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Please drop this patch. This won't work on MT7603 and later.

Yeah, I thought MT_INT_MASK_CSR is the same 0x0204 for all chips,
but for MT7603 this is MT_HIF(0x204). I assume we can still unify 
irq_lock, irqmask fields in common structure.

Anyway would be good to have mt7603 driver unstreamed, so we could
easily see what can be shared in mt76 generic code for all chips.

Felix, do you have plans to upstream it? Want some help with that ?

Thanks
Stanislaw
