Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4054AC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 117D520863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hz65kZrX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lZmYBIeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbfBAMkR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:40:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbfBAMkR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:40:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9DE6D608C5; Fri,  1 Feb 2019 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024816;
        bh=OpBj5prgLePnguZjTflRObE3i0CSxTk3bRvZ74boaeI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hz65kZrX9t/Z/miJ+I5MHHplBfMDCZTktdiM1UGd4PzIuneKLS1xzrMDBSvJfc9eC
         5iACmSCEB80wjRQ0t4FwZZVYYMMAraxkn5vSytwFQ77dM8m7rScYfz2o+XckpCIZOh
         fbTDWw437mJuPMwnzOXCrfg7MVIW9cU88YpnNxaA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5D52B608CC;
        Fri,  1 Feb 2019 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024815;
        bh=OpBj5prgLePnguZjTflRObE3i0CSxTk3bRvZ74boaeI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lZmYBIeWIGuSnUb27sD1Eax0MvORmp46Pt3i+QztoApGvnIx0KYO4MVmfzmI/1sy9
         ThaSe1OfUWGOcXetYR45xLfJoCQBWF67CjXNSYFatjHOj0c8CTFxrePT9dtGQFcWn8
         mfajHCCKVLngLkugrpqBY584ilh5lSxtfsTpqazg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5D52B608CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-38-gregkh@linuxfoundation.org>
References: <20190122152151.16139-38-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201124016.9DE6D608C5@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:40:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Cc: Ganapathi Bhat <gbhat@marvell.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Patch applied to wireless-drivers-next.git, thanks.

a0b449dc4c67 mwifiex: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775747/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

