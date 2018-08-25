Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbeHYPKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 11:10:38 -0400
Date: Sat, 25 Aug 2018 13:31:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 02/17] mt76: rename mt76x2_regs.h
Message-ID: <20180825113149.GA13833@redhat.com> (sfid-20180825_133211_588617_219525EA)
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
 <1535109321-17126-3-git-send-email-sgruszka@redhat.com>
 <2172355a-0703-e432-96cb-fba2383c3890@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2172355a-0703-e432-96cb-fba2383c3890@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 25, 2018 at 11:00:39AM +0200, Felix Fietkau wrote:
> On 2018-08-24 13:15, Stanislaw Gruszka wrote:
> > MAC registers are the same for mt76x0 and mt76x2. Rename mt76x2_regs.h
> > file to reflect that.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x2.h      |   2 +-
> >  drivers/net/wireless/mediatek/mt76/mt76x2_regs.h | 619 -----------------------
> >  drivers/net/wireless/mediatek/mt76/mt76xx_regs.h | 619 +++++++++++++++++++++++
> I think mt76xx_regs.h is named too generic. MT7603, MT7628, MT7615 and
> all newer chips use a completely different register layout.
> I'd prefer to stick with mt76x2_regs for now and use it for x0 as well.

I thought about that too, but choose it will be better to have some
prefix that will indicate the function/structure/header is shared between
the x0 and x2 drivers to not confuse mt76x2 code that is mt76x2 only
and one that is shared.

I choose mt76xx name, considered mt76 to be generic prefix shared also 
between old and new chips. But yeah this mt76xx name also "contains" new
chips. How about mt76old_ or mt76og_ (old generation) ?

Thanks
Stanislaw
