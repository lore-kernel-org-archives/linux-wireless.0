Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8245C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B85CA20815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q0tR2yWR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pNV+Cp1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbeLTREy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:04:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730771AbeLTREy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:04:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 650CC60734; Thu, 20 Dec 2018 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325493;
        bh=+N9lDQsHUgPhYRhFdkE7JwlRNODMJWbhaSzhuKsygMg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Q0tR2yWRjb44LB1f4NhvHg2IzX46hEwY6vpwONm15kRvhW2GM/qPkNJU2lG0lXr7Q
         6JG45PFZ67sm7794yx6/rQruHrfrJM08r1T6d5ay2G9f7jJW6k/m7/veY0SxRjsk/+
         OrXAxp2obuFz5+4vVuqnGtwLOE7kia6NnLdgXbqU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6FF3860734;
        Thu, 20 Dec 2018 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325492;
        bh=+N9lDQsHUgPhYRhFdkE7JwlRNODMJWbhaSzhuKsygMg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=pNV+Cp1ySkIqGyv/Z/ZZ6vEN+Wlj9hhPqJTl/5+AEqfi30UYy4AMVZCClnxjjnmil
         cAjybVv1D9ZLsb5zavhOyh6ZqZNne8L5creMlhj4E3Ax/QOeZcvUkoGwMMu0LAOTNC
         cp36Z+UG+tdRDNEtTB81xo3PJC1FO5uV4CzJovWk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6FF3860734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Remove work in progress logs from snoc driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181119113040.23294-1-govinds@codeaurora.org>
References: <20181119113040.23294-1-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170453.650CC60734@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:04:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> All the necessary patches to make wifi running (over SNOC)
> are merged and tested on SDM845/QCS404 platform with WCN3990
> wifi module, hence remove work in progress debug from snoc
> driver and Kconfig.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

876596759287 ath10k: remove work in progress logs from snoc driver

-- 
https://patchwork.kernel.org/patch/10688559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

