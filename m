Return-Path: <SRS0=bLdd=TA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4C5C43219
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 11:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170FE20675
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 11:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfD3L2F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Apr 2019 07:28:05 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:7899 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbfD3L2F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Apr 2019 07:28:05 -0400
X-UUID: e03d9aa27c904b4fbb8476405ca204f3-20190430
X-UUID: e03d9aa27c904b4fbb8476405ca204f3-20190430
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1463058352; Tue, 30 Apr 2019 19:27:59 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 30 Apr 2019 19:27:58 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 30 Apr 2019 19:27:58 +0800
Message-ID: <1556623678.4496.1.camel@mtkswgap22>
Subject: Re: [PATCH v2] mt76: mt7615: add TX/RX antenna pattern capabilities
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 30 Apr 2019 19:27:58 +0800
In-Reply-To: <c3f6e202-8c2f-a103-a104-e0d1cde8147b@nbd.name>
References: <4f7160cb9f52335ce15fccac087fec25e7650884.1556255852.git.ryder.lee@mediatek.com>
         <c3f6e202-8c2f-a103-a104-e0d1cde8147b@nbd.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-30 at 11:24 +0200, Felix Fietkau wrote:
> On 2019-04-26 07:23, Ryder Lee wrote:
> > Announce antenna pattern cap to adapt PHY and baseband settings.
> > 
> > Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> > ---
> > Changes since v2:
> > - Add a prefix mt76 in the title.
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
> > index 3ab3ff553ef2..122f7a565540 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
> > @@ -190,6 +190,8 @@ int mt7615_register_device(struct mt7615_dev *dev)
> >  			IEEE80211_VHT_CAP_SHORT_GI_160 |
> >  			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
> >  			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
> > +			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
> > +			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN |
> If I read the standard correctly, these flags indicate that the rx/tx
> antenna pattern does NOT change during association.
> Doesn't that mean that we should set it in mac80211.c instead, so that
> it also applies to MT76x2?
> 
Right. I will add these flags in common code.

Ryder


