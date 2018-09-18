Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeIRSMt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:12:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] mt76x0: run vco calibration for each channel configuration
References: <20180907211312.17918-1-lorenzo.bianconi@redhat.com>
        <20180918114356.GB15285@redhat.com>
        <20180918120234.GD15285@redhat.com>
Date: Tue, 18 Sep 2018 15:40:19 +0300
In-Reply-To: <20180918120234.GD15285@redhat.com> (Stanislaw Gruszka's message
        of "Tue, 18 Sep 2018 14:02:35 +0200")
Message-ID: <871s9r2d3g.fsf@kamboji.qca.qualcomm.com> (sfid-20180918_144027_080874_4D32DBAF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, Sep 18, 2018 at 01:43:56PM +0200, Stanislaw Gruszka wrote:
>> On Fri, Sep 07, 2018 at 11:13:12PM +0200, Lorenzo Bianconi wrote:
>> > According to vendor sdk, vco calibration has to be executed
>> > for each channel configuration whereas mcu calibration has to be
>> > performed during channel scanning. This patch fixes the mt76x0
>> > monitor mode issue since in that configuration vco calibration
>> > was never executed
>> > 
>> > Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
>> > Tested-by: Sid Hayn <sidhayn@gmail.com>
>> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> 
>> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> For the record this is 4.19 material.

I really want to minimise conflicts and because of so many mt76 patches
conflicts are likely to happen, so I'm keeping the bar high for mt76
patches going 4.19. Is this a regression from 4.18? If not, I think this
should go to -next and cc stable. And besides, monitor mode isn't that
critical anyway.

-- 
Kalle Valo
