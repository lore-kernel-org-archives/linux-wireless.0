Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE38C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110B520693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iHK8fTJU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IWtuMgT0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfDYQjM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:39:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfDYQjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:39:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 18E2360736; Thu, 25 Apr 2019 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210351;
        bh=PZpQLBcyzlZ7DgLRWE9xhgSQNiMv2360fySLfO+mGDM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iHK8fTJUic5vgvxla3EDi+Sq6sVO/sAhitlsAKxahQWSgn9d0ybc6HdVZ2JP8NYMS
         ewa2e9bWjTRPXv0D/w6SR2cdAvqK/kvkzO5sR0pnd23A0wBaBpJgP30jspX3Kr9Feg
         MFKucAC186a4Rzz6lAE8r/n56J8Oc0wPg4escjog=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28FA2601B4;
        Thu, 25 Apr 2019 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210350;
        bh=PZpQLBcyzlZ7DgLRWE9xhgSQNiMv2360fySLfO+mGDM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IWtuMgT01qgiSjIh4X0ETWqyaBB8dKKwxh7T/eN8sKdYcWntD8lL0op1U1/nJJ1Ew
         xiEmUVFhJ8WSLI09+VBq/vttwkIEHTiYaiXNgFfYAtj2Nr0Z/2MwotBUKeNvz6zfcf
         pJ1YUrTympQ8ZdCRSmQEIkmG9tH0CoArWzmChGBA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28FA2601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ray_cs: use remove_proc_subtree to simplify procfs code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190306114812.30480-1-yuehaibing@huawei.com>
References: <20190306114812.30480-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425163911.18E2360736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:39:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Use remove_proc_subtree to remove the whole subtree
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

3b6edcb3fffe ray_cs: use remove_proc_subtree to simplify procfs code

-- 
https://patchwork.kernel.org/patch/10840991/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

