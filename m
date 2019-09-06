Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3761C43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DACC20842
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nhY1H0Ou";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FdvsUbhD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394075AbfIFOPk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 10:15:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731458AbfIFOPj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A3D876115B; Fri,  6 Sep 2019 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779338;
        bh=YxWVDgNYq3t0Z/Me2htRzh5Q3a84zN7UuKetlbZ9CzU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nhY1H0Ou74lN75hpPtr8ZQWhuuGxuHzuI2pJc6U5HMRnDq4alru2wx6UsAA/BxsUU
         J6zG/VgsQAcjOs6k03rsAHEjHV9hVSAom4nPK2kt3C9o+bnjGYWHZrgM1wgtPSNsf6
         CDbqHpyf7Ivp+H87So1A8VGcWtmYLw7z/+iiqf1Y=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2271B602EE;
        Fri,  6 Sep 2019 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779338;
        bh=YxWVDgNYq3t0Z/Me2htRzh5Q3a84zN7UuKetlbZ9CzU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FdvsUbhDVLNrotUI/UUy2bR+ZZmda8cbKF3qhQSGK15azzSqk8mNgNGVWOC9wgU0s
         HYGpdYjmMVUApLpDAIC4W3LcvJfJDD0/+oeGLCTdI6uBJqJS10Ehd14IaiumTGrtnd
         j6ac3BhEDBzS0Y+wJCpMDBrbgnlKecN62T4kTmwE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2271B602EE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] zd1211rw: use %*ph to print small buffer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190904175323.77984-1-andriy.shevchenko@linux.intel.com>
References: <20190904175323.77984-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190906141538.A3D876115B@smtp.codeaurora.org>
Date:   Fri,  6 Sep 2019 14:15:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied to wireless-drivers-next.git, thanks.

d13b12c30c34 zd1211rw: use %*ph to print small buffer

-- 
https://patchwork.kernel.org/patch/11131201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

