Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AF1C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 14:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 604342171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 14:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E03h9cSc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E03h9cSc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbfB1OXo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:23:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51910 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfB1OXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 09:23:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E3C4E60907; Thu, 28 Feb 2019 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551363822;
        bh=riIc+Njp80QQ24g/rukS7BDkGPZxPm+GJL+zb2NLL4A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=E03h9cScCkDW304PSwKrCcLjONiHJiqW70fEwJv69IA/x2lT1H01RKUaHWrCew/2j
         Epdd5our13fRNKhi1dtBM/4Bh1M8YF3zeOneMX4AlCkDaY0PaFTeZlDwd2tmHpGmb6
         XAVRmNQuuJIYWaaTzr3LmTdzZwXjlWsHsybJbKwQ=
Received: from x230.qca.qualcomm.com (85-76-47-1-nat.elisa-mobile.fi [85.76.47.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E7C46013C;
        Thu, 28 Feb 2019 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551363822;
        bh=riIc+Njp80QQ24g/rukS7BDkGPZxPm+GJL+zb2NLL4A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=E03h9cScCkDW304PSwKrCcLjONiHJiqW70fEwJv69IA/x2lT1H01RKUaHWrCew/2j
         Epdd5our13fRNKhi1dtBM/4Bh1M8YF3zeOneMX4AlCkDaY0PaFTeZlDwd2tmHpGmb6
         XAVRmNQuuJIYWaaTzr3LmTdzZwXjlWsHsybJbKwQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E7C46013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 07/12] mt76x02: fix hdr pointer in write txwi for USB
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
        <1551341013-24519-8-git-send-email-sgruszka@redhat.com>
        <20190228093819.GA2768@localhost.localdomain>
        <20190228135208.GA8852@redhat.com>
Date:   Thu, 28 Feb 2019 16:23:38 +0200
In-Reply-To: <20190228135208.GA8852@redhat.com> (Stanislaw Gruszka's message
        of "Thu, 28 Feb 2019 14:52:09 +0100")
Message-ID: <87lg20at5h.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Feb 28, 2019 at 10:38:20AM +0100, Lorenzo Bianconi wrote:
>> > Since we add txwi at the begining of skb->data, it no longer point
>> > to ieee80211_hdr. This breaks settings TS bit for probe response and
>> > beacons.
>> > 
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> >  drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
>> > index fdd6a021914d..bcf3126efda9 100644
>> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
>> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
>> > @@ -85,8 +85,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
>> >  
>> >  	mt76x02_insert_hdr_pad(skb);
>> >  
>> > -	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
>> > +	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
>> >  	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
>> > +	skb_push(skb, sizeof(struct mt76x02_txwi));
>> >  
>> >  	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
>> >  	txwi->pktid = pid;
>> > -- 
>> > 2.20.1
>> > 
>> 
>> Good catch :)
>> I think we should post it ontop of wireless-drivers since sw encryption is not
>> working now.
>> 
>> Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>
> I can send it against 5.0, if Kalle will accept it, however
> I do not have practical bug associated with this. Maybe we
> sometimes can send ordinal frame with TS bit in txwi and it
> is then malformed by HW, but I'm not sure. IBSS work with
> this bug, not sure about MESH.

Too late for 5.0 as Linus will most likely release it on Sunday. I
recommend sending it to wireless-drivers-next so that I can queue it for
5.1.

-- 
Kalle Valo
