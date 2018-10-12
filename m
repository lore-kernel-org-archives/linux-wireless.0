Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE56C6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F54520865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YKB7udLv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YKB7udLv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F54520865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbeJLWb5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 18:31:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbeJLWb5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 18:31:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B8CF660866; Fri, 12 Oct 2018 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539356346;
        bh=/3VmPGxbzdBYVaWP9jAdmLz9YbBJF7d20lM58VOeArE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YKB7udLvu4plYCEovwIlDqqL5enrJTYXkh2jkJYVRRZp/Th2rKWvHOdei8dcCqe1l
         gcx1M6qgZir1C4RV3okckknv/j0o4dgZiAkspNc7uOtR7Lnf1ISDBZX3TCIs6/h3gw
         vF83TWUVpN+uAGOnrSHakg/Q8V0o4dTKVc4Sg1vk=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 58BAB60B7A;
        Fri, 12 Oct 2018 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539356346;
        bh=/3VmPGxbzdBYVaWP9jAdmLz9YbBJF7d20lM58VOeArE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YKB7udLvu4plYCEovwIlDqqL5enrJTYXkh2jkJYVRRZp/Th2rKWvHOdei8dcCqe1l
         gcx1M6qgZir1C4RV3okckknv/j0o4dgZiAkspNc7uOtR7Lnf1ISDBZX3TCIs6/h3gw
         vF83TWUVpN+uAGOnrSHakg/Q8V0o4dTKVc4Sg1vk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 58BAB60B7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add peer flush in ath10k_flush for STATION
References: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
Date:   Fri, 12 Oct 2018 17:59:03 +0300
In-Reply-To: <1538989363-12386-1-git-send-email-wgong@codeaurora.org> (Wen
        Gong's message of "Mon, 8 Oct 2018 17:02:43 +0800")
Message-ID: <87zhvj2oug.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> writes:

> In the noisy environment, if there are packets in the queue and can't
> send out, the suspend timing will be more than 5 seconds due to the wait,
> flush the queue to optimize the suspend timing, and let the upper layer to
> retry the packets after resume.
>
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
>  drivers/net/wireless/ath/ath10k/mac.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

The patch is slightly corrupted, there should be a "---" line before the
diffstat and that broke my patchwork script. I fixed it now in the
pending branch, but be careful if you manually edit patch files.

-- 
Kalle Valo
