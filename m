Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBDEC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594972147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a/mlxsyi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U+pDQCE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfBGO5j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:57:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfBGO5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:57:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D01D860247; Thu,  7 Feb 2019 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551458;
        bh=NlvPg/IHPsrn/k730+rNSqWAHDzhndrbAeqd1185C6k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a/mlxsyimmbFH0WouVJTA6lYOwBowa+qEVXqYtZqBtDIO1wJ1fpM/uaY3hwJKOD00
         H6Sc63PgWGz97HRUMIgw+Cz6kENjWhb2E0vo4ruCQJpc7AeZTwZxt1D8RAzQEBYPq0
         3zsJqnjsMCNKRd/GMpsGpFojE9KXT/29A58B2io0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BB5060131;
        Thu,  7 Feb 2019 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551458;
        bh=NlvPg/IHPsrn/k730+rNSqWAHDzhndrbAeqd1185C6k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=U+pDQCE5ky0p70D9ZHOn57znKk3cMtPA5MMRdgqzG0fBPXnnDL+KefHGfBnwZKs3P
         hh37x3JOa8SKtuoDXpM22sGxcEBrpDf6psTdtMZir9QA6bDJX6sk90wChEwT3+V5Vz
         f8wrXDlHxkiLivxiVFDB2HVoMW/8P56xW8KfW11s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BB5060131
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add a condtion to fill the LDPC capability
 correctly
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
References: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145738.D01D860247@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:57:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> wrote:

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
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1,
>            WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ff488d0ef1c2 ath10k: add a condition to fill the LDPC capability correctly

-- 
https://patchwork.kernel.org/patch/10791807/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

