Return-Path: <SRS0=EMPu=SC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045E9C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 08:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD3A72146F
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 08:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfCaIxD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Mar 2019 04:53:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:26983 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725888AbfCaIxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Mar 2019 04:53:03 -0400
X-UUID: 8d69f16f37b741ecb85afd0828595b67-20190331
X-UUID: 8d69f16f37b741ecb85afd0828595b67-20190331
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1985671103; Sun, 31 Mar 2019 16:52:52 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sun, 31 Mar 2019 16:52:51 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sun, 31 Mar 2019 16:52:51 +0800
Message-ID: <1554022371.17453.0.camel@mtkswgap22>
Subject: Re: [PATCH 1/4] mt76: add mac80211 driver for MT7615 PCIe-based
 chipsets
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Sean Wang <sean.wang@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "YF Luo" <yf.luo@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Haipin Liang <haipin.liang@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, Roy Luo <royluo@google.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>,
        Kai Lin <kai.lin@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Date:   Sun, 31 Mar 2019 16:52:51 +0800
In-Reply-To: <87lg0wyjvj.fsf@purkki.adurom.net>
References: <cover.1553607739.git.ryder.lee@mediatek.com>
         <2849359e0b0ede6c13ae9f142aff77a016fd0a80.1553607739.git.ryder.lee@mediatek.com>
         <87lg0wyjvj.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-03-30 at 08:08 +0200, Kalle Valo wrote:
> Ryder Lee <ryder.lee@mediatek.com> writes:
> 
> > This driver is for a newer generation of MediaTek MT7615 4x4 802.11ac
> > PCIe-based chipsets, which support wave2 MU-MIMO up to 4 users/group
> > and also support up to 160MHz bandwidth.
> >
> > The driver fully supports AP, station and monitor mode.
> >
> > Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> > Signed-off-by: Roy Luo <royluo@google.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]
> 
> > --- /dev/null
> > +++ b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
> > @@ -0,0 +1,204 @@
> > +// SPDX-License-Identifier: GPL-2.0
> 
> mt76 is under ISC so why did you choose GPLv2 here? I don't think it's a
> good idea to use different licenses within the same driver.
> 
> Also mt76 does not use SPDX tags yet. I would prefer that the whole
> driver is converted in one go to have consistent licensing information.
> 

OK. I will modify it.

