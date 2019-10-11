Return-Path: <SRS0=YUKO=YE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E829ECE58C
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Oct 2019 08:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63DD22190F
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Oct 2019 08:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gXsxcfYG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c+cCrfoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfJKIxh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Oct 2019 04:53:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJKIxh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Oct 2019 04:53:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7675C60791; Fri, 11 Oct 2019 08:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570784016;
        bh=B1nJDhxTQ/e2NJsYTGupIirDTTmjjX1VIfseAaQfZ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gXsxcfYGoaC2vxdcadFn1AS6GsxbwHnsidqLrl5N2jFfcWBICI+Mg1ivqKl+oV0Da
         xyLl9nogWzDOIqjqYu55hgzsBE3QWE7ToLgWoVMtn6saRSBDUzDPPiBI3baFkkXYkP
         RREqUioClukQ6op3PX3N+LglvqdO0oyQKmlp/lwk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFFD3602DC;
        Fri, 11 Oct 2019 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570784016;
        bh=B1nJDhxTQ/e2NJsYTGupIirDTTmjjX1VIfseAaQfZ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=c+cCrfoGz+vfkBX6an+T6ug2h3NSlEXITVrRMjvijVkmYV8vw/TDire3tlSehftnm
         DTPqearSyxR7YzXWNaEpeP6sKT8u4a4NupUngiv0k0gniJn6BL6fNA1yLALqMX3pIf
         pExhEBbW2a2o+ldD+qP7l01pG2a8Yld6c5Y4Dh+k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFFD3602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191011085336.7675C60791@smtp.codeaurora.org>
Date:   Fri, 11 Oct 2019 08:53:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

59f4567d228f rtlwifi: rtl8192ee: Remove set but not used variable 'err'

-- 
https://patchwork.kernel.org/patch/11180853/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

