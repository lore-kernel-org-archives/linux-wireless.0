Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53008C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E372082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GSk7GFhJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GSk7GFhJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfBDPdB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:33:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBDPdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:33:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5C52E6090F; Mon,  4 Feb 2019 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294380;
        bh=yuj15vr8DZ1zUhI8LIzqgERxwwGIHijsyVcEvMxrSKI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GSk7GFhJ8BoW6es9SxESHAA6L9sKN+uWinMgPE7z/ATNI/H5zBCZSwThLqfCZnQlj
         zsABJRz1XV93AS56Q1aWoL6GwFW4t8OjlyYRVoY7BkVTg6gVSTInXn9uiL3a0KEv56
         cjS/FfJbphXFjoB2DY7iJEl9thnK0rXYcsvt6aP0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1EA166032C;
        Mon,  4 Feb 2019 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294380;
        bh=yuj15vr8DZ1zUhI8LIzqgERxwwGIHijsyVcEvMxrSKI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GSk7GFhJ8BoW6es9SxESHAA6L9sKN+uWinMgPE7z/ATNI/H5zBCZSwThLqfCZnQlj
         zsABJRz1XV93AS56Q1aWoL6GwFW4t8OjlyYRVoY7BkVTg6gVSTInXn9uiL3a0KEv56
         cjS/FfJbphXFjoB2DY7iJEl9thnK0rXYcsvt6aP0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1EA166032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add a condtion to fill the LDPC capability correctly
References: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
Date:   Mon, 04 Feb 2019 17:32:56 +0200
In-Reply-To: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
        (Surabhi Vishnoi's message of "Fri, 1 Feb 2019 11:04:22 +0530")
Message-ID: <877eefefh3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> The firmware advertises the LDPC support information for HT in
> HT capability info in the wmi service ready event. To provide
> granularity, firmware now advertises WMI_HT_CAP_RX_LDPC and
> WMI_HT_CAP_TX_LDPC separately. To support LDPC, host should
> also check for WMI_HT_CAP_RX_LDPC and WMI_HT_CAP_TX_LDPC in HT
> capabilities.
>
> Add a condition to existing logic in host to know whether firmware
> supports LDPC or not.
>
> Tested HW: WCN3990
> Tested SW: WLAN.HL.2.0

Can you give exact firmware version you tested, please? I'll add it to
the commit log.

I'll also fix the typo "condtion" in the title.

-- 
Kalle Valo
