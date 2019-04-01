Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78C6C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 09:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 817C720896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 09:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfDAJqj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 05:46:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfDAJqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 05:46:39 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B39981106;
        Mon,  1 Apr 2019 09:46:38 +0000 (UTC)
Received: from localhost (unknown [10.40.205.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E7BA1A7D4;
        Mon,  1 Apr 2019 09:46:35 +0000 (UTC)
Date:   Mon, 1 Apr 2019 11:46:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <royluo@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH 1/4] mt76: add mac80211 driver for MT7615 PCIe-based
 chipsets
Message-ID: <20190401094633.GC19802@redhat.com>
References: <cover.1553607739.git.ryder.lee@mediatek.com>
 <2849359e0b0ede6c13ae9f142aff77a016fd0a80.1553607739.git.ryder.lee@mediatek.com>
 <87lg0wyjvj.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lg0wyjvj.fsf@purkki.adurom.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 01 Apr 2019 09:46:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 30, 2019 at 08:08:32AM +0200, Kalle Valo wrote:
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

mt76x0 is GPL only as some parts of it are modified copy of either out
of tree Mediatek GPL driver or Jakub's mt7601u also realised under GPL.

Is ISC equal to "Dual BSD/GPL" what is marked by MODULE_LICENSE ?
I think this should be clarified too.

> Also mt76 does not use SPDX tags yet. I would prefer that the whole
> driver is converted in one go to have consistent licensing information.

Agree. However not sure if we can unify of all mt76 code to the same
license (and which one: GPL ?), but at least we can convert source 
files to SPDX identifier.

Stanislaw
