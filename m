Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242DFC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB88520659
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wm94S2Q8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fkWK8M2u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB88520659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJNAj3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:39:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeJNAj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:39:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4C9E060BFE; Sat, 13 Oct 2018 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450095;
        bh=JRRlTklxr00OLvB6qjz/O3GcwVLWbrot8fu2WBiQass=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wm94S2Q8ltGPUq5eFNu6YRYYv3MLATfUpo00L0AFModr7mSVLMHg163nAnzmTQMN/
         AgLG8tpyro7WWJdO3JBcmgKOavE/xNLV5uz85InNNQGUR09Y1P0lr15723S90EXP2E
         4D/7alIvlDqr0Ae7drzdrBX4JiAgfjkinNniK/4k=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77D5C60A98;
        Sat, 13 Oct 2018 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450094;
        bh=JRRlTklxr00OLvB6qjz/O3GcwVLWbrot8fu2WBiQass=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fkWK8M2uYEpwlSgKs9/RwlLsfGGMx1kuYsjJ9ckAe9fHYl969j1FP60okO24CRarj
         O2tH7Zfd8qZit4mR+ownTU8FPR0extzH+soKMETEwsbMcVoOfz67J4mFUiZsWmDfbS
         Y5qG8bEDL/0F6bHAjsWXKEqEnqtlotToYpmvSXUk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 77D5C60A98
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] brcmsmac: AP mode: update beacon when TIM changes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181003162139.17014-1-alimjalnasrawy@gmail.com>
References: <20181003162139.17014-1-alimjalnasrawy@gmail.com>
To:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013170135.4C9E060BFE@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:01:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com> wrote:

> Beacons are not updated to reflect TIM changes. This is not compliant with
> power-saving client stations as the beacons do not have valid TIM and can
> cause the network to stall at random occasions and to have highly variable
> latencies.
> Fix it by updating beacon templates on mac80211 set_tim callback.
> 
> Addresses an issue described in:
> https://marc.info/?i=20180911163534.21312d08%20()%20manjaro
> 
> Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

2258ee58baa5 brcmsmac: AP mode: update beacon when TIM changes

-- 
https://patchwork.kernel.org/patch/10625067/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

