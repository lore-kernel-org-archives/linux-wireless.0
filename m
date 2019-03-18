Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C47DC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC442070D
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfCRK0J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbfCRK0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:26:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE288308425A;
        Mon, 18 Mar 2019 10:26:09 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 543165C28F;
        Mon, 18 Mar 2019 10:26:09 +0000 (UTC)
Date:   Mon, 18 Mar 2019 11:21:35 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/6] mt76: store software PN/IV in wcid
Message-ID: <20190318102134.GC3323@redhat.com>
References: <20190316204242.73560-1-nbd@nbd.name>
 <20190316204242.73560-4-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190316204242.73560-4-nbd@nbd.name>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 18 Mar 2019 10:26:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 16, 2019 at 09:42:40PM +0100, Felix Fietkau wrote:
> Avoids expensive 64-bit atomic access in the data path
<snip>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> index d6e260ca1423..fb1961ac9dc6 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> @@ -924,7 +924,11 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
>  	txwi[3] = cpu_to_le32(val);
>  
>  	if (key) {
> -		u64 pn = atomic64_inc_return(&key->tx_pn);
> +		u64 pn;
> +
> +		spin_lock(&dev->mt76.lock);
> +		pn = ++wcid->tx_pn;
> +		spin_unlock(&dev->mt76.lock);

It's interesting that atomic op is more expensive that taking spinlock
and do the operation under spinlock protection. This should not be
the case, atomic ops are provided exactly to avoid locking and should
be faster than spin_lock. Perhaps on architecture where this happen
(presumably MIPS 32bit) either atomic ops assembly code should be fixed
or arch should switch generic lib/atomic64.c .

Stanislaw
