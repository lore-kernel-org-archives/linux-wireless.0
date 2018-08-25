Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36178 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbeHYPff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 11:35:35 -0400
Subject: Re: [PATCH 02/17] mt76: rename mt76x2_regs.h
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
 <1535109321-17126-3-git-send-email-sgruszka@redhat.com>
 <2172355a-0703-e432-96cb-fba2383c3890@nbd.name>
 <20180825113149.GA13833@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f5537708-b3b6-1d0c-1461-7a08ca48b51b@nbd.name> (sfid-20180825_135724_674999_E134BBE7)
Date: Sat, 25 Aug 2018 13:56:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180825113149.GA13833@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-25 13:31, Stanislaw Gruszka wrote:
> On Sat, Aug 25, 2018 at 11:00:39AM +0200, Felix Fietkau wrote:
>> On 2018-08-24 13:15, Stanislaw Gruszka wrote:
>> > MAC registers are the same for mt76x0 and mt76x2. Rename mt76x2_regs.h
>> > file to reflect that.
>> > 
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> >  drivers/net/wireless/mediatek/mt76/mt76x2.h      |   2 +-
>> >  drivers/net/wireless/mediatek/mt76/mt76x2_regs.h | 619 -----------------------
>> >  drivers/net/wireless/mediatek/mt76/mt76xx_regs.h | 619 +++++++++++++++++++++++
>> I think mt76xx_regs.h is named too generic. MT7603, MT7628, MT7615 and
>> all newer chips use a completely different register layout.
>> I'd prefer to stick with mt76x2_regs for now and use it for x0 as well.
> 
> I thought about that too, but choose it will be better to have some
> prefix that will indicate the function/structure/header is shared between
> the x0 and x2 drivers to not confuse mt76x2 code that is mt76x2 only
> and one that is shared.
> 
> I choose mt76xx name, considered mt76 to be generic prefix shared also 
> between old and new chips. But yeah this mt76xx name also "contains" new
> chips. How about mt76old_ or mt76og_ (old generation) ?
I think this looks even more confusing. Also, please keep in mind that
'old' is relative as well.
How about mt76x02?

- Felix
