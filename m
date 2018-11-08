Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54487ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2966C2077B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2966C2077B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbeKIB2U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 20:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbeKIB2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 20:28:20 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B85183F3E;
        Thu,  8 Nov 2018 15:52:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 298915C224;
        Thu,  8 Nov 2018 15:52:09 +0000 (UTC)
Date:   Thu, 8 Nov 2018 16:52:03 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 1/4] mt76x02: configure basic rates and fallback on STA
 mode
Message-ID: <20181108155202.GA13621@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
 <CAJ0CqmXdvqdfQNXqxBmPn_t_EA7wg2hCd87rrwC+7N_y+8bh=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmXdvqdfQNXqxBmPn_t_EA7wg2hCd87rrwC+7N_y+8bh=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 08 Nov 2018 15:52:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 08, 2018 at 03:58:29PM +0100, Lorenzo Bianconi wrote:
> > For STA mode configure legacy basic rates according to info
> > mac80211 provides to us, as well as follback registers, which
> > are setup in vendor driver under CONFIG_STA_SUPPORT .
> > For LB_FBK_CFG1 register use values from vendor driver, which
> > are different for mt76x0 and mt76x2 .
> >
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > index 87ce6a51fb05..2be4b527477f 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > @@ -678,6 +678,18 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
> >                 tasklet_enable(&dev->pre_tbtt_tasklet);
> >         }
> >
> > +       if (changed & BSS_CHANGED_BASIC_RATES &&
> > +           vif->type == NL80211_IFTYPE_STATION) {
> > +               mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
> > +               mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
> > +               if (is_mt76x2(dev))
> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x87872100);
> > +               else
> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x00872100);
> > +       }
> > +
> 
> since these values are constant, why not put them init_vals?

I wanted them to be used only in STA mode like vendor driver does.
However if we will have AP+STA , we still will configure them,
so better to configure them anyway and put in init_vals .

Thanks
Stanislaw

