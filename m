Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35120 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbeIJO0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 10:26:44 -0400
Subject: Re: [PATCH 39/42] mt76: move some irq code to common mmio module
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-40-git-send-email-sgruszka@redhat.com>
 <91c0c1d5-12a9-7155-c4bf-191a511080ee@nbd.name>
 <20180906104348.GE16539@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <6759963b-6a37-f635-9d6a-4022624d867e@nbd.name> (sfid-20180910_113338_887944_E0279AD5)
Date: Mon, 10 Sep 2018 11:33:33 +0200
MIME-Version: 1.0
In-Reply-To: <20180906104348.GE16539@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 12:43, Stanislaw Gruszka wrote:
> On Thu, Sep 06, 2018 at 11:33:55AM +0200, Felix Fietkau wrote:
>> On 2018-09-06 11:18, Stanislaw Gruszka wrote:
>> > Move some irq handling code to generic mmio module.
>> > 
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Please drop this patch. This won't work on MT7603 and later.
> 
> Yeah, I thought MT_INT_MASK_CSR is the same 0x0204 for all chips,
> but for MT7603 this is MT_HIF(0x204). I assume we can still unify 
> irq_lock, irqmask fields in common structure.
> 
> Anyway would be good to have mt7603 driver unstreamed, so we could
> easily see what can be shared in mt76 generic code for all chips.
> 
> Felix, do you have plans to upstream it? Want some help with that ?
I plan on sending it upstream soon. It's still not fully stable, but
that shouldn't be a blocker.

- Felix
