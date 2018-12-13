Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DD3C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185962086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N/XS4PgN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ky0zFPJ0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 185962086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbeLMPEg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:04:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56694 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeLMPEg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 10:04:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 48CC2608CB; Thu, 13 Dec 2018 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713475;
        bh=4EN5Py3pOtDZYQZ6pGLEhbVF/6DBAgFjLfB31KdOpec=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N/XS4PgNbejIs5upxK0pJcu8Sp0g6MDI3VEi27kfj+7ZyDQasb7p06OzomvqY34Pa
         r+eemRc+VyNf17pNVCfAT7DDhawp5ybAjhdmvCgPLd4t+HvRGv0l4Qe+09OhCG+Uqh
         16hp0z7B8anF4LQwb7iR7EPHYM+gpoxO+9WtU9NA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3026960867;
        Thu, 13 Dec 2018 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713474;
        bh=4EN5Py3pOtDZYQZ6pGLEhbVF/6DBAgFjLfB31KdOpec=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ky0zFPJ01JVDe8wc0ex0bbAXBuhYNrJuDAO40kXVsUfjtBK9MFE3HouFbbEdAGyQ4
         WvgCYt4wjNMOUC5AxcWN+sp0/32426J4PAlRCwwNAxkqtn7KbLhm4giJoIChjNly/a
         s3j4MWlJ+jmJ6ywP3IBO67nioKZflTyYi+CxhbNw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3026960867
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: remove set but not used variable
 'type' in translate_rx_signal_stuff
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1544097968-68563-1-git-send-email-yuehaibing@huawei.com>
References: <1544097968-68563-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213150435.48CC2608CB@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 15:04:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c: In function 'translate_rx_signal_stuff':
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c:309:6: warning:
>  variable 'type' set but not used [-Wunused-but-set-variable]
> 
> It never used since commit 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from
> staging to regular tree")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

e3e454b7047a rtlwifi: rtl8821ae: remove set but not used variable 'type' in translate_rx_signal_stuff

-- 
https://patchwork.kernel.org/patch/10715629/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

