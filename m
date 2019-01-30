Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AB8C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2992184D
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 10:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NBZ0qkg3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iNTtLRUc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfA3KLJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:11:09 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbfA3KLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 05:11:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4E15E608FB; Wed, 30 Jan 2019 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548843068;
        bh=90PolSr+hoyTmkKlHJl22/0XCg1DMPyJbJd29yI2WZk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NBZ0qkg3cQ3Nban+CFVdtJSVY9o6Dr3mLD4DWufRwMt6IPwdH4ogANPws+1AMR+3T
         /qONwAUPioLF1jsgxGQoW1SRyYPVM/xoPC4lMOPpvdwdY/cfUeVnI1tm7uLYT2jRBH
         ejOLxZrouoZbGcsf3x68+hqwAlgx/qVW2IcSxNYg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36D7B60540;
        Wed, 30 Jan 2019 10:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548843066;
        bh=90PolSr+hoyTmkKlHJl22/0XCg1DMPyJbJd29yI2WZk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iNTtLRUcqRuGVpfbK2ELUaI1DCEYqF0OmVKS0E2hQbOS4mv5BWmwyLwTXnzEretBG
         DtaFxCHR3v1AHb6iBU2jNAhMdajSjbzQPDjm0vyf0+ClPTMUrRGdIbLwu3Z96VU9r3
         awrf4FxIUNj1g0i1ufPujL+6OyXIIy2e5To1LbKc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36D7B60540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Wen Gong <wgong@codeaurora.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-5.0] ath10k: correct bus type for WCN3990
References: <20190129231201.42230-1-briannorris@chromium.org>
Date:   Wed, 30 Jan 2019 12:11:01 +0200
In-Reply-To: <20190129231201.42230-1-briannorris@chromium.org> (Brian Norris's
        message of "Tue, 29 Jan 2019 15:12:01 -0800")
Message-ID: <87k1imlakq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> WCN3990 is SNOC, not PCI. This prevents probing WCN3990.
>
> Fixes: 367c899f622c ("ath10k: add bus type check in ath10k_init_hw_params")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> This was a regression in 4.20.

I'll queue this for 5.0.

-- 
Kalle Valo
