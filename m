Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BDFC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 14:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F164218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 14:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FM+RJ2AV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gufEsTkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfAYOA2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 09:00:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfAYOA2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 09:00:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 427576055A; Fri, 25 Jan 2019 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548424827;
        bh=ehXPbhJFeMdXUUc+4fZwHYoJyPkc8XefiSU3OoDTRZs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FM+RJ2AVQ1dgfI6GX3Obf+g3xPfjCKWVwdo0dIGAUnbHakYOUTK2YfmxX61zd9ivs
         eh4Z0YEqgbWAZMW9/y0PoSb2VBFBwP7O3VIG0wQlHV9MZT98By4WKtGRo1dI6biEjH
         NpCXiUiTAodjspodQ/J/nmG+zMNY/sfFmh2PzStM=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CEDC460795;
        Fri, 25 Jan 2019 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548424826;
        bh=ehXPbhJFeMdXUUc+4fZwHYoJyPkc8XefiSU3OoDTRZs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gufEsTkDbPXdG1IOb4wxGWyN3ti2mphUAlYk+eNAzedxZJNaCXFV5AZPbp5h7k5RT
         qc9uyyW5rHhVdvv5QS6tzxCLtrXYvaoIlDsfxK5QlAz36ckBBuTAf54AlwySNje8Bd
         y1BHu8saKQlKgO/jnEfPBQwPFt96BsP6ZPSt14zA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CEDC460795
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix dma unmap direction for management frames
References: <1548390066-12305-1-git-send-email-pillair@codeaurora.org>
Date:   Fri, 25 Jan 2019 16:00:23 +0200
In-Reply-To: <1548390066-12305-1-git-send-email-pillair@codeaurora.org>
        (Rakesh Pillai's message of "Fri, 25 Jan 2019 09:51:06 +0530")
Message-ID: <87o9843ki0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> writes:

> The management frames transmitted are dma mapped with
> direction TO_DEVICE, but incorrectly mapped with
> direction FROM_DEVICE during tx complete and error cases.
>
> Fix the direction of dma during dma unmap of the
> transmitted management frames.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>
> Fixes: 38a1390e02b7

This should be:

Fixes: 38a1390e02b7 ("ath10k: dma unmap mgmt tx buffer if wmi cmd send fails")

I'll fix that in the pending branch.

-- 
Kalle Valo
