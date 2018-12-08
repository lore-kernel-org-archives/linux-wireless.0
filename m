Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C090CC04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 18:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BC522083D
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 18:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m6TF3DNg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LgKOhBZ+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BC522083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbeLHSIo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 13:08:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbeLHSIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 13:08:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 78FD560A98; Sat,  8 Dec 2018 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544292523;
        bh=e01HRYTvgC84NYQsy5BnAfyOzpPEOheoIh8fh6Rlr4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m6TF3DNge9KVri+w+6KfVJyfn0TC7scQMbuQJDVTSbAk1YW9WwXmtdayOKn7xibWA
         CW9JStdgesEBr7tq4rwGOwjceQKwPlsF4USUUm0ZHfEkdi8Tyi0lydiyv+baMeNLHH
         5nTLUYstwNvAoX4Eh9EERlBluc+eLg1LkCepeJ3M=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A884C6019F;
        Sat,  8 Dec 2018 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544292522;
        bh=e01HRYTvgC84NYQsy5BnAfyOzpPEOheoIh8fh6Rlr4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LgKOhBZ+J/Ru2E7Hj3a0/iQ9KV6fILl5raM79YY7XvPDzGqtvLOpsdXm2rUv6m5PX
         ugniXcXs4sNlfbF+xsCs03WNVX1auRwnvGN8zNaPWxaslLyNDISiPs6TU2yw38tJer
         Ld1/qlmqj8Cl2ZLcnXFmz8TPh+SKWY8tkqSjdk/8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 08 Dec 2018 20:08:42 +0200
From:   merez@codeaurora.org
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wil6210: remove set but not used variable 'wdev'
In-Reply-To: <1543996743-137124-1-git-send-email-yuehaibing@huawei.com>
References: <1543996743-137124-1-git-send-email-yuehaibing@huawei.com>
Message-ID: <93252d599bfcf6073c612d4386e2b7bc@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-05 09:59, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/wil6210/main.c: In function 
> '_wil6210_disconnect':
> drivers/net/wireless/ath/wil6210/main.c:407:23: warning:
>  variable 'wdev' set but not used [-Wunused-but-set-variable]
> 
> It never used since commit ("e1b43407c034 wil6210: refactor disconnect 
> flow")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/ath/wil6210/main.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Maya Erez <merez@codeaurora.org>
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
