Return-Path: <SRS0=WqAe=ZU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41759C432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 08:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14EF921771
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 08:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c8ZnJTk9";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YeDrXnG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfK1IFL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:05:11 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:40704
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbfK1IFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Nov 2019 03:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574928310;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=GxwUw6Gq7BL40TcTKR/Z4WDw9MS/45w0vLNGTTYaQzY=;
        b=c8ZnJTk9ljbbhAnj4IAq+UwOBbuinmzV2aLwu9bb31AhNsn9rAD6x5sTGz4gPANX
        M84Be2lCtZQQgnccF7ZTqwSYSir9FiPn6ZrYCmMV8kSJQLxB2UC8wk1Mp6/GjSQn3I8
        KCVT/AXkUZ0X7jshnqUGkzJ3peJCJ8DPb2ICRFt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574928310;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=GxwUw6Gq7BL40TcTKR/Z4WDw9MS/45w0vLNGTTYaQzY=;
        b=YeDrXnG45KJhWRjTEy95dLwFGEOlP26Mm/L9fBIG05WfIpjCT5d/Uhx/V1b7gj3O
        YKcNZFzLcXiX1AMd1zw/UaqmEvmPOjxp0jRhNhrib3HTB8nmfA8tWvM2ycqSa17BxiR
        Ehjxnpy7cMCnDQCGqmB/K17CQ1a/o+033EIP/b4M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35FD8C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Fix heap overflow in
 mmwifiex_process_tdls_action_frame()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <E40E893E-D9B4-4C63-8139-1DD5E1C2CECB@gmail.com>
References: <E40E893E-D9B4-4C63-8139-1DD5E1C2CECB@gmail.com>
To:     qize wang <wangqize888888888@gmail.com>
Cc:     linux-wireless@vger.kernel.org, amitkarwar <amitkarwar@gmail.com>,
        nishants <nishants@marvell.com>, gbhat <gbhat@marvell.com>,
        huxinming820 <huxinming820@gmail.com>, Greg KH <greg@kroah.com>,
        "dan.carpenter" <dan.carpenter@oracle.com>,
        Solar Designer <solar@openwall.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016eb10adf1b-06d87453-6fe9-414b-9114-23b8e50c5c3e-000000@us-west-2.amazonses.com>
Date:   Thu, 28 Nov 2019 08:05:10 +0000
X-SES-Outgoing: 2019.11.28-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

qize wang <wangqize888888888@gmail.com> wrote:

> mwifiex_process_tdls_action_frame() without checking
> the incoming tdls infomation element's vality before use it,
> this may cause multi heap buffer overflows.
> 
> Fix them by putting vality check before use it.
> 
> Signed-off-by: qize wang <wangqize888888888@gmail.com>

Please fix the commit log as explained by Dan.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11257535/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

