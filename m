Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3510C48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 07:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E4B2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 07:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hmrAD0Ms";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G0u6Dtd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfFYHr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 03:47:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfFYHr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 03:47:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B97E7608CE; Tue, 25 Jun 2019 07:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561448876;
        bh=MQrHqQH3XNeC/N18epLjG2PdBDcJlDo4vlk/jEXzCtU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hmrAD0Msu4BcG2LvKr3/e9ScEyFvzW5T8EHrUmU26Axzmk0rnXknVLc03brI3bxtM
         KtA3ZWLMt+IrgzaoHAzWA6F1hpBSNrO6TD5PvHgKS6owROakKfQErrGoO3gdnMc8+d
         j9xnSt6or6AoEovkaINzotTogTPEadqpk1XFIcsQ=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84959602F1;
        Tue, 25 Jun 2019 07:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561448875;
        bh=MQrHqQH3XNeC/N18epLjG2PdBDcJlDo4vlk/jEXzCtU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G0u6Dtd9q7IOUCzP6f/X7Rgc0Po0Ds1ktqEQH+BgDSKUPYsN8IgAdlUNeS5DFndAR
         jmonP38OMu8aRswwAAB6mnh3mAv1DGwWfGRx5ns0AiuG+kVZRCQ+36N4C5WfiCyuwg
         dhtfnZZECJfFjcmEpSghdS4nBJ8GtKX30CCo9FjY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84959602F1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20190625160432.533aa140@canb.auug.org.au>
        <8736jyfaje.fsf@codeaurora.org>
        <20190625163608.1aa15ad3@canb.auug.org.au>
        <alpine.DEB.2.21.1906250856050.32342@nanos.tec.linutronix.de>
Date:   Tue, 25 Jun 2019 10:47:50 +0300
In-Reply-To: <alpine.DEB.2.21.1906250856050.32342@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Tue, 25 Jun 2019 08:56:54 +0200
        (CEST)")
Message-ID: <87r27ids2h.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Tue, 25 Jun 2019, Stephen Rothwell wrote:
>
>> Hi Kalle,
>> 
>> On Tue, 25 Jun 2019 09:23:33 +0300 Kalle Valo <kvalo@codeaurora.org> wrote:
>> >
>> > Thanks for the report. Any suggestions how to handle this? Or do we let
>> > Linus take care of this?
>> 
>> Just let Linus take care of it ... mention it in the pull request ... I
>> guess DaveM needs to know, right?
>
> Ah. I didn't realize that this is a new commit in Kalle's tree. So yes
> that's the right thing to do.

Good, I'll do that then.

-- 
Kalle Valo
