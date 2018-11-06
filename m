Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE23AC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6DB42085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y1iFeJfU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AlhPdP8+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6DB42085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389356AbeKGCRR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:17:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52598 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389337AbeKGCRR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:17:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E9F0607F7; Tue,  6 Nov 2018 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523072;
        bh=Yot+JRu1qZxNNVUfBI1s1nn8nUCDzpcUDNAuvNgczXg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y1iFeJfUeJ6l1QucNWh+42KgF1YjIYqf4e0uAacQGNDM1EVVifhwxUPF+c/G4OpcP
         YGdINUx22OEb2Cl7MUqyvg2pwDxhZ5PPuF9m1vVS8MKqCuNy2hKg4OUT1xSjwv/Fuh
         BAHupnyNgqf6rGslyJkkBt9arhvSyxqQL1lOJbmY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 973836038E;
        Tue,  6 Nov 2018 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523071;
        bh=Yot+JRu1qZxNNVUfBI1s1nn8nUCDzpcUDNAuvNgczXg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=AlhPdP8+JLLRRqtAIrmTmlhNa5fldcZ/3YTQFcSZVUCWveX90o5t4GtwSHk3Qgbk9
         zGBbz3uRRBDfaTCPE0VKx8fYuYRzNyM3zsv4GsRpWwvX1PA1pcm94+59VIn6aSowfp
         67pRU8AIOK1uBKmveSO2187uw0h579SCD+B3Rb1g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 973836038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/6] brcmfmac: Remove firmware-loading code duplication
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181010110103.21857-1-hdegoede@redhat.com>
References: <20181010110103.21857-1-hdegoede@redhat.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165112.0E9F0607F7@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:51:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> wrote:

> brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
> code to complete the fw-request depending on the item-type.
> 
> This commit adds a new brcmf_fw_complete_request helper removing this code
> duplication.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

6 patches applied to wireless-drivers-next.git, thanks.

a1a3b7621638 brcmfmac: Remove firmware-loading code duplication
5b587496dc63 brcmfmac: Remove recursion from firmware load error handling
eae8e50669e1 brcmfmac: Add support for first trying to get a board specific nvram file
0ad4b55b2f29 brcmfmac: Set board_type used for nvram file selection to machine-compatible
bd1e82bb420a brcmfmac: Set board_type from DMI on x86 based machines
55e491edbf14 brcmfmac: Cleanup brcmf_fw_request_done()

-- 
https://patchwork.kernel.org/patch/10634355/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

