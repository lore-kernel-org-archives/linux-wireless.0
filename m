Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37DBC2D0BF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 08:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79272206D5
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 08:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Kwf6G9HY";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Yp+XY/n7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfLJIkR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 03:40:17 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:33238
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbfLJIkR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 03:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575967217;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=fOSeUDSXD4k3xsXzc2NAuCAKHE+fDsanSEdUG+v8K8o=;
        b=Kwf6G9HY5kgd4pSCcBYhDIKWo0YPvOt2ibgoMpgtxwKAd8Sw6bASo0DiQYxsFxtX
        Dk9nSgkzDpC2aO0CCMal8g0RumzV4LXVL6vh8ReqyBpaOxeLzG0xiRST8SrR3LhZMgi
        RvenqgnR2ODmld9sE+7kco5eYjnm7zRwMfF2e2SY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575967216;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=fOSeUDSXD4k3xsXzc2NAuCAKHE+fDsanSEdUG+v8K8o=;
        b=Yp+XY/n7w6UJhEqecuj9b2hAgW5qzfmR1n5J8kyEYbsRAVjI18jvo6WGNnHPtZu+
        SndGpF2dYj15K8rkvVGjDBPK352mIAhLzvozBLyceh+G3svrbpbU3/Jnmq0BHbjan5i
        Mczdt5DUwsehnZU2gIWsKUMHkXzhI3um6xVd0odE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ADB77C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5.5] iwlwifi: pcie: move power gating workaround earlier
 in the flow
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191205070354.231246-1-luca@coelho.fi>
References: <20191205070354.231246-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016eeef754e1-c3b4e10c-2934-43f0-bcf9-b086e89114d8-000000@us-west-2.amazonses.com>
Date:   Tue, 10 Dec 2019 08:40:16 +0000
X-SES-Outgoing: 2019.12.10-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> We need to reset the NIC after setting the bits to enable power
> gating and that cannot be done too late in the flow otherwise it
> cleans other registers and things that were already configured,
> causing initialization to fail.
> 
> In order to fix this, move the function to the common code in trans.c
> so it can be called directly from there at an earlier point, just
> after the reset we already do during initialization.
> 
> Fixes: 9a47cb988338 ("iwlwifi: pcie: add workaround for power gating in integrated 22000")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205719
> Cc: stable@ver.kernel.org # 5.4+
> Reported-by: Anders Kaseorg <andersk@mit.edu>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

0df36b90c47d iwlwifi: pcie: move power gating workaround earlier in the flow

-- 
https://patchwork.kernel.org/patch/11274279/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

