Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE65C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6424A206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NEp4eV30";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SyCfsMxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfDYQvf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:51:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQve (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:51:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2A3B360736; Thu, 25 Apr 2019 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211094;
        bh=jbJQxBU4yKZUB7FmKegsnvXKkYqaoplxFiO1cp4pmfU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NEp4eV30ZgEIg2vH2mXWA2K2paLOFSSRbwwOqqjhBZVD0cJ9gz6bfFsG1rZZgj6Ig
         bd4sMZe2oHhLL94qpP58AV2F2dAntNsTdfD8abBDxJMdpX4PqQgb3hyCXd7S0vyMUw
         ocDd7aCOxK3Uv0dkuayr9cpcfsaCr14pRbpsbaHM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED1F36019D;
        Thu, 25 Apr 2019 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211093;
        bh=jbJQxBU4yKZUB7FmKegsnvXKkYqaoplxFiO1cp4pmfU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SyCfsMxFmzW2RF/DbAvBTyzPTYSm1+On0DmHzbtLCmwgsqlcA25ACVLDGklnH1Rbl
         xJk+CYjwa9WxuyKpbLpIm901WsBbFlsLoUADpALC+ICyWOBzkc+RoJa+EQC8IOi00j
         ejpnAnuBjj3uPpwajlWbVlyW8pueKnH9bsMRF7as=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ED1F36019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: Remove empty function lpphy_papd_cal()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190404184914.12819-1-Larry.Finger@lwfinger.net>
References: <20190404184914.12819-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@arndb.de>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165134.2A3B360736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:51:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit d825db346270e ("b43: shut up clang -Wuninitialized variable
> warning"), the message noted that function lpphy_papd_cal() was empty
> and had an old TODO regarding its implementation. As the reverse
> engineering project that created the LP-PHY version of this driver
> has not been active for some time, it is safe to remove this empty
> function.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

b25105e126e7 b43: Remove empty function lpphy_papd_cal()

-- 
https://patchwork.kernel.org/patch/10886095/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

