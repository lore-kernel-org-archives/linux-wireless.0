Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1F3C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09CA20835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jSlci5yI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YQ9J1RZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A09CA20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbeJNBEV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:04:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeJNBEU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:04:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F163460BF7; Sat, 13 Oct 2018 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451581;
        bh=eESKFF+qtluJMDswkyTYnA3Mv003dBeRgms6EYoO51o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jSlci5yIKADmpbAMySUptMZkTYDMWC33jCBPtBblk0kdIhbULwC6zY5gc6BIiiP+z
         AQIolzcQLZW8xUtGyNEgNtBnPRKSRKafcbWL2UB28dTVjCMUX0ngxoB2ye4wipfE1n
         nR3g6sDtyohwxSrnJ/KFGKxF2VqVq/XeZYMn1r70=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4FCE60116;
        Sat, 13 Oct 2018 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451580;
        bh=eESKFF+qtluJMDswkyTYnA3Mv003dBeRgms6EYoO51o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YQ9J1RZOYsNVoFCD2I5ivXWRZI69HN5YhdMcHhEEKQZKBV+UYkh6t/ND8fL0DM4yG
         OXHN+EtinLf3q6ZUPJ22aTde2sM9tH24ILm9IMjOnJtVhKcjx/WglVXcIKIa78x5AX
         Xl06Gbo+mOmwpIeRmMcLCSksWJXULWNtHWd2IUTo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4FCE60116
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V3] ath10k: allocate small size dma memory in
 ath10k_pci_diag_write_mem
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539244526-31912-1-git-send-email-cjhuang@codeaurora.org>
References: <1539244526-31912-1-git-send-email-cjhuang@codeaurora.org>
To:     Carl Huang <cjhuang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013172620.F163460BF7@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:26:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Carl Huang <cjhuang@codeaurora.org> wrote:

> ath10k_pci_diag_write_mem may allocate big size of the dma memory
> based on the parameter nbytes. Take firmware diag download as
> example, the biggest size is about 500K. In some systems, the
> allocation is likely to fail because it can't acquire such a large
> contiguous dma memory.
> 
> The fix is to allocate a small size dma memory. In the loop,
> driver copies the data to the allocated dma memory and writes to
> the destination until all the data is written.
> 
> Tested with QCA6174 PCI with
> firmware-6.bin_WLAN.RM.4.4.1-00119-QCARMSWP-1, this also affects
> QCA9377 PCI.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Reviewed-by: Brian Norris <briannorris@chomium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0738b4998c6d ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem

-- 
https://patchwork.kernel.org/patch/10636245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

