Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CEAC67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B7B12086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hykeMyEM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I4HOuMX4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7B12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbeLMPD2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:03:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbeLMPD2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 10:03:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D14DF60735; Thu, 13 Dec 2018 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713407;
        bh=1aiwPgfEWXSfAE2Zg7C277hozC8g2Yp9+ekM/vTlpUY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hykeMyEM08v4pueOSVgB/lIJwArAmPg3B/cb45hrInctJKSvXqGhR6vPP1mml2IxW
         US+h9AmTnEt5TidpAUBjVq+5042DMLb/JBjFxZ+eehqS0G56TDHu89/1i+HG1C3mua
         /7l4t/Yh7GUgvMBstsubw5OX4MBA183FsjO0yR3g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 574926013C;
        Thu, 13 Dec 2018 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713407;
        bh=1aiwPgfEWXSfAE2Zg7C277hozC8g2Yp9+ekM/vTlpUY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=I4HOuMX4oLyLDZcnyZCmeTqnXUy9zc0jpNAAnCF8AjIH4YeZ8Nj8lJxruLNL2basF
         mGNb9vLnQkj03YbvAGP2bDExPTeM4pJNylexVmKiYLi5Jq0CUqzi0fynqYwgEdng1S
         7NyFYLBjoCly/gbvqzyB0X2W4aeAZSeDbFck12K8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 574926013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl818x: fix potential use after free
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1543488490-101743-1-git-send-email-bianpan2016@163.com>
References: <1543488490-101743-1-git-send-email-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213150327.D14DF60735@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 15:03:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pan Bian <bianpan2016@163.com> wrote:

> entry is released via usb_put_urb just after calling usb_submit_urb.
> However, entry is used if the submission fails, resulting in a use after
> free bug. The patch fixes this.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

afbb1947db94 rtl818x: fix potential use after free

-- 
https://patchwork.kernel.org/patch/10704331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

