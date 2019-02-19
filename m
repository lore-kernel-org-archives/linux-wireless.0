Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDD2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACD7020859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fiJDh2T5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j/r88St3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfBSPIh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:08:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfBSPIh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:08:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D43B9608CD; Tue, 19 Feb 2019 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588917;
        bh=QXOIOE3FTkNysuaJ1lWpSFwNlcJoNhxhvmH5KxEUpFY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fiJDh2T5H4dJQLPftNaSASwO1Dt1asTGZdgcq/3VaoCZGK6ztZ5DWXYr2+FbSfkSN
         VwoD+FjzK91OqsBpEYPW8Wsc1XAvpSYdcFUlNicEtw2B+dr52b5zSb0Wed5h4TPBQd
         o8orHwuFiYeGBHRYwztV8dICMkqynLjwjqHwewjc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D8AB60388;
        Tue, 19 Feb 2019 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588916;
        bh=QXOIOE3FTkNysuaJ1lWpSFwNlcJoNhxhvmH5KxEUpFY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=j/r88St31hwOHsEqZ7g85la5xmierq6zwl5iNR35vUF5JVcuYnRDXMUVSTXxeMqwU
         8PW5p42/wufosdR4ud7xyYU2UIzSRlmyQj/2QwMwWRjZRSmNtF7vZn+JAnTFdWlGqU
         scAaFtRp06vdMgUmqObB0bzZO/XdgmX4ss2ifUro=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D8AB60388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix a typo in a debug message
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190209090009.GA4865@kadam>
References: <20190209090009.GA4865@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150836.D43B9608CD@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:08:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> There is a \b (backspace) character in the message that wasn't intended.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

e8242ad03883 rsi: fix a typo in a debug message

-- 
https://patchwork.kernel.org/patch/10804409/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

