Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E7DC04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 13:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB302086E
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 13:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cEV3BXn5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cEV3BXn5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACB302086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbeK0AAo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 19:00:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeK0AAo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 19:00:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DCA43614F9; Mon, 26 Nov 2018 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543237598;
        bh=WABLagpy7L4+R1S6LR9wIu5rT77bxtrakv+SDQLfUdQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cEV3BXn549qWBLLGdFvoQa4pCKbFzjP59aoe1Hn65brYk70KMZZ9eifYxdgL2qR80
         aC5qWURNo72QGEfiqHlhTMhHZ7ff7rAaiKnEmnFENeYik6TNzp8Gm6KpElHB8jBJkH
         48f7CayiSy5QQ8zO080fjjjROJ2enyCRqLl/JoVY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9267861421;
        Mon, 26 Nov 2018 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543237598;
        bh=WABLagpy7L4+R1S6LR9wIu5rT77bxtrakv+SDQLfUdQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cEV3BXn549qWBLLGdFvoQa4pCKbFzjP59aoe1Hn65brYk70KMZZ9eifYxdgL2qR80
         aC5qWURNo72QGEfiqHlhTMhHZ7ff7rAaiKnEmnFENeYik6TNzp8Gm6KpElHB8jBJkH
         48f7CayiSy5QQ8zO080fjjjROJ2enyCRqLl/JoVY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9267861421
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Govind Singh <govinds@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix a NULL vs IS_ERR() check
References: <20181126081143.tvu55aimdc3safcq@kili.mountain>
        <8736rob60p.fsf@kamboji.qca.qualcomm.com>
        <20181126083021.GC3088@unbuntlaptop>
Date:   Mon, 26 Nov 2018 15:06:33 +0200
In-Reply-To: <20181126083021.GC3088@unbuntlaptop> (Dan Carpenter's message of
        "Mon, 26 Nov 2018 11:30:22 +0300")
Message-ID: <87va4k9eee.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Mon, Nov 26, 2018 at 10:24:38AM +0200, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> 
>> > The devm_memremap() function doesn't return NULLs, it returns error
>> > pointers.
>> >
>> > Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > ---
>> >  drivers/net/wireless/ath/ath10k/qmi.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
>> > index f0429bee35c2..37b3bd629f48 100644
>> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
>> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
>> > @@ -931,9 +931,9 @@ static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi, u32 msa_size)
>> >  		qmi->msa_mem_size = resource_size(&r);
>> >  		qmi->msa_va = devm_memremap(dev, qmi->msa_pa, qmi->msa_mem_size,
>> >  					    MEMREMAP_WT);
>> > -		if (!qmi->msa_va) {
>> > +		if (IS_ERR(qmi->msa_va)) {
>> >  			dev_err(dev, "failed to map memory region: %pa\n", &r.start);
>> > -			return -EBUSY;
>> > +			return PTR_ERR(qmi->msa_va);
>> 
>> That's a very good find!
>> 
>> But how has this even worked before?
>
> This only changes the error path.  Presumably it always succeeds in real
> life.

Ah, I missed the "!" operator. Yeah, I think you are correct. I'll queue
this for -next then.

-- 
Kalle Valo
