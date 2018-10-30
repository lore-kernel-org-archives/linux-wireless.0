Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA42CC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 10:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 919EB2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 10:23:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dzrc8mLS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rx5pGSQy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 919EB2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbeJ3TQh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 15:16:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbeJ3TQh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 15:16:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1CFE760791; Tue, 30 Oct 2018 10:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540895025;
        bh=LaDE3dvVLvVwdBfZevPp5P0DLyfNSjlImNR50pKKHLE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dzrc8mLSfRZqDjBjqo4BJXVVI4rwq0d4ALHShNIIahxNm4+9c853IY4ojPfeA/GkA
         VOClMVnTC3vodZzn83oauomDtCBMtoRUCt7qIMpoZU7EDBbOApXnPAFU+cGjH+aIzw
         C9ndCWmw/zY/R1C3vPcGSrAaFUNISqV8AWzpI7UU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7CB55602BD;
        Tue, 30 Oct 2018 10:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540895024;
        bh=LaDE3dvVLvVwdBfZevPp5P0DLyfNSjlImNR50pKKHLE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Rx5pGSQySphI6J3NuBeyDLD1gpt7NkNekC71tmHf0geo7Xr6I0ME4mv5GxkVfpJX1
         P39cVmOTjWChoReTKabHJARIRaAsg8/PIlH2zjSnmeo9qxabRuK0n4Q/euSp8nRvFq
         0RF7HBPxNe4D1l/oE6x0I+yIqhJb4mCBwIk8ZWg8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7CB55602BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: run calibration after scanning
References: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
        <87zhuwbzj8.fsf@purkki.adurom.net> <20181030093655.GA26345@redhat.com>
Date:   Tue, 30 Oct 2018 12:23:40 +0200
In-Reply-To: <20181030093655.GA26345@redhat.com> (Stanislaw Gruszka's message
        of "Tue, 30 Oct 2018 10:36:56 +0100")
Message-ID: <87bm7bg2c3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Mon, Oct 29, 2018 at 04:25:31PM +0200, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>> > If we are associated and scanning is performed , sw_scan_complete callback
>> > is done after we get back to operating channel, so we do not perform
>> > phy calibration and queue cal work. Fix this by run calibration from
>> > sw_scan_complete().
>> >
>> > Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > ---
>> > This is for 4.20
>> 
>> So what are the symptoms from user's point of view? Is this a
>> regression?
>
> We do not perform gain calibration any longer if somebody will
> request scan after association. This is formally a regression,
> but calibration code changed a lot, so perhaps this can be dropped
> for 4.20 and eventually go through -stable if I can confirm
> it fixes performance problems.

To me that would be a much better option, less conflicts that way.

-- 
Kalle Valo
