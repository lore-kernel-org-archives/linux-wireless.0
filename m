Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2030C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD3220892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFD3220892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbeLGNZN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeLGNZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 08:25:12 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A34230A7BBD;
        Fri,  7 Dec 2018 13:25:12 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C11C36C205;
        Fri,  7 Dec 2018 13:25:03 +0000 (UTC)
Date:   Fri, 7 Dec 2018 14:25:01 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 1/4] mt76x02: configure basic rates and fallback on STA
 mode
Message-ID: <20181207132501.GA3454@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
 <CAJ0CqmXdvqdfQNXqxBmPn_t_EA7wg2hCd87rrwC+7N_y+8bh=g@mail.gmail.com>
 <20181108155202.GA13621@redhat.com>
 <d89224d5-da5b-a4ac-d6a8-7d9f5cdf779d@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d89224d5-da5b-a4ac-d6a8-7d9f5cdf779d@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 07 Dec 2018 13:25:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 08, 2018 at 05:02:14PM +0100, Felix Fietkau wrote:
> >> > +       if (changed & BSS_CHANGED_BASIC_RATES &&
> >> > +           vif->type == NL80211_IFTYPE_STATION) {
> >> > +               mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);

It's a bit hard to interpret how vendor driver set LEGACY_BIT_RATE
in MlmeUpdateTxRates(). It seems to always enable bits for
OFDM6/OFDM12/OFDM24 (bitmask 0x150) or maybe just do this for 5GHz,
I'm not sure. Need more investigation on this.
 
> >> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
> >> > +               mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
> >> > +               mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
> >> > +               if (is_mt76x2(dev))
> >> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x87872100);
> >> > +               else
> >> > +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x00872100);
> >> > +       }
> >> > +
> >> 
> >> since these values are constant, why not put them init_vals?
> > 
> > I wanted them to be used only in STA mode like vendor driver does.
> > However if we will have AP+STA , we still will configure them,
> > so better to configure them anyway and put in init_vals .
> Yes, I think we should put them in initvals. Also, I think we should
> keep the values the shared between mt76x0 and mt76x2.
> 
> For MT_LG_FBK_CFG1 there is no need to make a distinction between 76x2
> and 76x0, because 76x0 will simply ignore the upper values (they apply
> to 2SS transmission only).
> Also, I don't think MT_VHT_HT_FBK_CFG1 even gets used on mt76x0, because
> it is for 2SS rates only. However, the value in there seems more useful
> than the one we currently use on mt76x2, because it allows fallback from
> 2SS MCS0 to 1SS MCS0.
> The contents of MT_LG_FBK_CFG0 also match the default initialization
> values documented in the 7612E datasheet.
> 
> I don't think there is any meaningful difference between the 76x2 and
> the 76x0 MAC except for the missing 2SS support.

Since there are different initvals tables for mt76x2 and mt76x0, I use
different values of MT_LG_FBK_CFG1. Will post a patches soon, please
comment there, if something is not correct.

Thanks
Stanislaw
