Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CDAC432C3
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 07:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE7D20723
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 07:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bWuhGVJL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E47RPSOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfKPHwC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 02:52:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfKPHwC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 02:52:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 52E1C61014; Sat, 16 Nov 2019 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573890721;
        bh=5IbSK3rPZdO2NHSKbA3WuCwgwfaJIOSGDuXA+44GJho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bWuhGVJLEBVRgDPzKuNhBYS2BIJsLzGPAw5zdHwlwCBs5UwwQjL0M3J6MpaPvy3HX
         B42kyL9y9G92FrYsv9pZX0bhG/uMIAIbmG5M/9NPOClKPQ687qctvJhUVVQlGka8dc
         B5T/CDCHaoCxM9hzh5VjW6WW4mpKRRRWwKtP9aL8=
Received: from x230.qca.qualcomm.com (176-93-0-138.bb.dnainternet.fi [176.93.0.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E1B160B19;
        Sat, 16 Nov 2019 07:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573890720;
        bh=5IbSK3rPZdO2NHSKbA3WuCwgwfaJIOSGDuXA+44GJho=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=E47RPSOnWqjf/4i9ypO3VEv8ZuI3yFs+hphAF0L2hcVQggrVZbyN5CzDn1szTKj1z
         VGDslsqWHwFLnIoITRxjzXn5RMUA++E/XnMVTUFlrTQluZMi2pghQbJoZZMJftV1hU
         7xGS7/EJm6djf8bfc4gqN9Us0fVgwxBpw7spo1eU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E1B160B19
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <stas.yakovlev@gmail.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH -next 2/2] ipw2x00: remove set but not used variable 'force_update'
References: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
        <1573890083-33761-3-git-send-email-zhengbin13@huawei.com>
Date:   Sat, 16 Nov 2019 09:51:57 +0200
In-Reply-To: <1573890083-33761-3-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Sat, 16 Nov 2019 15:41:23 +0800")
Message-ID: <87tv74uule.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin <zhengbin13@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/intel/ipw2x00/ipw2100.c: In function shim__set_security:
> drivers/net/wireless/intel/ipw2x00/ipw2100.c:5582:9: warning: variable force_update set but not used [-Wunused-but-set-variable]
>
> It is introduced by commit 367a1092b555 ("ipw2x00:
> move under intel vendor directory"), but never used, so remove it.

Same here, I'll remove this sentence as well.

-- 
Kalle Valo
