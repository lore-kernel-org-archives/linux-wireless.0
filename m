Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F6DC64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 13:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159372054F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 13:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a196ll1T";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j82uTcTs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 159372054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbeJIUxe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 16:53:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbeJIUxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 16:53:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9CB6160BFA; Tue,  9 Oct 2018 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539092194;
        bh=UMP25JtbIO/rDDCdmcsK2asEmRlsHpABIZO9O/yQKuQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a196ll1TFUTMDCFu9i0IcRiHTPagNt6GdoI619co/OBUZfCW9wzRt6cgtxx96bHrJ
         VyA7MA1N5Vb8SlvwwOmPR+FZvPFZxwVtamxG9K41pNAuxXisp9Ip0U0EMJ6xnu3OoW
         yFNpkaqbjUwnZSekyuppTZg4oVpdj4NCwABVdQNQ=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCE1760769;
        Tue,  9 Oct 2018 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539092193;
        bh=UMP25JtbIO/rDDCdmcsK2asEmRlsHpABIZO9O/yQKuQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=j82uTcTsoPXxjg2wBpwYmhEtUj72o2msJk8msmW3JAbNQDim1DEsBGH9a2+xMTwpl
         eMMYK7vblspOqdktVTaNV2e0IeTounuOSr3Ftp1x3KvFKLEFZ1NZ1sEi+4ZblpLkfN
         NaSNzMUq3J0KHwtXII9LWg+4NH5edia5AssFUMao=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCE1760769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Daniel Mack <daniel@zonque.org>, Chris Ball <chris@printf.net>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: call into generic suspend code before turning off power
References: <20181008200357.10819-1-daniel@zonque.org>
        <CAPDyKFoo-gnjUg9Khc3EPm=cvHgyR_VNW8xgjP1Tea7wjRfvSw@mail.gmail.com>
Date:   Tue, 09 Oct 2018 16:36:30 +0300
In-Reply-To: <CAPDyKFoo-gnjUg9Khc3EPm=cvHgyR_VNW8xgjP1Tea7wjRfvSw@mail.gmail.com>
        (Ulf Hansson's message of "Tue, 9 Oct 2018 09:43:38 +0200")
Message-ID: <87efczqm1t.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On 8 October 2018 at 22:03, Daniel Mack <daniel@zonque.org> wrote:
>> When powering down a SDIO connected card during suspend, make sure to call
>> into the generic lbs_suspend() function before pulling the plug. This will
>> make sure the card is successfully deregistered from the system to avoid
>> communication to the card starving out.
>>
>> Fixes: 7444a8092906 ("libertas: fix suspend and resume for SDIO connected cards")
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> BTW, if you need this to reach 4.19 I have already queued some other
> mmc fixes so I can take this as well, if it helps. I need and ack of
> course.

I'm not planning to send anything to 4.19 anymore and this is so simple
that hopefully it cause any conflicts with -next patches, so feel free
to do that:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
