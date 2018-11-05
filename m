Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4FEC46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E9520869
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IADJ+1gu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XEt2yWnZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92E9520869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbeKEUbo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:31:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeKEUbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:31:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 289C260AD8; Mon,  5 Nov 2018 11:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416353;
        bh=nagwEuImJjA11ZEolLPlBP9kifGUh8PIxeGs/4Obtek=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IADJ+1guu0vcPaVMNoWVWvKYxr/VrtJShT1eVhk9vX/jZUx0rBwgFJ+LNkpSRXiZA
         Hw3FOnfZEw62QS7QYctADrWpvxIsjJMXhwbAK7+BQcXUXB8yyW10d0E81bGz4jAXM5
         AtPPkO+ZKop9q2h5K3WBcDnyEcDOLK4kPVvb3V/M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B72496044B;
        Mon,  5 Nov 2018 11:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416352;
        bh=nagwEuImJjA11ZEolLPlBP9kifGUh8PIxeGs/4Obtek=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XEt2yWnZco3Mo2NXxqU3H1fM2wbKptPoGmb/kfQxeXSU6Nsqjy173RVLdU2Z0OnOV
         OtsbTEOEoyPUqbzL3G31lWEmIuaqkWsQa2rvXw8ql7xEE50p93DpfVIf00z4vaUmob
         TJGN+/8xhKH2kwg4r1OTaKMLjkY8fGxYu/brO60I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B72496044B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][ath10k-next] ath10k: fix some spelling mistakes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181018215104.10444-1-colin.king@canonical.com>
References: <20181018215104.10444-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105111233.289C260AD8@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:12:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Trivial fix to some spelling mistakes in ath10k_err and ath10k_dbg
> messages:
> "capablity" -> "capability"
> "registed" -> "registered"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

eb9bd8b963d6 ath10k: fix some spelling mistakes

-- 
https://patchwork.kernel.org/patch/10648317/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

