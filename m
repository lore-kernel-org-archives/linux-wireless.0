Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E88CC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 181A82075B
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LZj1XsLh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IQI/loJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfDMLRF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 07:17:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41138 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfDMLRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 07:17:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B195E61782; Sat, 13 Apr 2019 11:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555154223;
        bh=1E2sBow9pwBe5eaOerLz99QPd+b+ZHQug8S4yArLkXQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LZj1XsLhFWN4idbIiTtPHoMlb6SXa+U8H2quUF8BZJdFFTSjy6CiyCjPigx/5LSCF
         yb27PcW/oiYNEqTHMcLBP0Q/f5Qi2PmEoDWC0gwQJ3H9YXg2B9t9KuKsaR10f6U8WE
         c4Bnetd0+BuYQcTb+KaGSe+hSte5U4oUw4JvGPpM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15E9D616D6;
        Sat, 13 Apr 2019 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555154223;
        bh=1E2sBow9pwBe5eaOerLz99QPd+b+ZHQug8S4yArLkXQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IQI/loJGcpvl7LDFK6A3MC1o4mBaSJWjHhxDUY0+9KiRYduHOcqP/ztFq/8sgSDbo
         J1qlcMhhMR8dtWhyCTQv0u3wCAYaQeKuwkODPn6lN0O66Hzvs73Lm4Hv+sk5+rZWx8
         9VJIycP2lCJF/0WJ5unlqY/0rSXfPLSwJ+IkVUWQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15E9D616D6
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] rtlwifi: Fix duplicate tests of one of the RX
 descriptors
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190404182931.9477-2-Larry.Finger@lwfinger.net>
References: <20190404182931.9477-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190413111703.B195E61782@smtp.codeaurora.org>
Date:   Sat, 13 Apr 2019 11:17:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In drivers rtl8188ee, rtl8821ae, rtl8723be, and rtl8192ee, the reason
> for a wake-up is returned in the fourth RX descriptor in bits 29-31. Due
> to typographical errors, all but rtl8821ae test bit 31 twice and fail to
> test bit 29.
> 
> This error causes no problems as the tests are only used to set bits in
> the output of an optional debugging statement.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

2 patches applied to wireless-drivers-next.git, thanks.

0961d9874a2e rtlwifi: Fix duplicate tests of one of the RX descriptors
ddab2eee7949 rtlwifi: Convert the wake_match variable to local

-- 
https://patchwork.kernel.org/patch/10886071/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

