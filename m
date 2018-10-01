Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9C9C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3AE02064A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BiPmIlEk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AP9bAdLC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3AE02064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbeJAPr1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:47:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbeJAPr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:47:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0F52260BEE; Mon,  1 Oct 2018 09:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538385041;
        bh=g2OBnhjqdBMTcYXZ0F+ku0BkdpdA8dJMV2zPnOAPZAA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BiPmIlEkCBBQaZ+9X7N4j7BIt+2ixTUyXTwnrtnAhaZxs/mp7Q6qIeW7Rrb/z5+1Y
         5OpslZgE14/4CpFcQUtzFVhOIqjPQIW3XLOwOosI+ukMP8NUtlj5t4a1rKe9veVgSu
         sYfZbPxgi8hJNV2i3ddSjdC7T6iE48dq00Fyp6wc=
Received: from x230.qca.qualcomm.com (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EEC9A60B7A;
        Mon,  1 Oct 2018 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538385040;
        bh=g2OBnhjqdBMTcYXZ0F+ku0BkdpdA8dJMV2zPnOAPZAA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AP9bAdLCJ9gbc/LWVS1OhhG9Ql/L6OKPFHZD8gdNen/SOogRF0cw735ONDJaDlHPs
         1/DFoEwpfwbLh0zNKYspdWdWSsU7QefLW8SbsZPfkwGnC1V9fZP52uTsgkO+wVQdnG
         oYR/3bZg7ji5J1VKW3wv6SI5Y4dz8HYkdKlB2AWI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EEC9A60B7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <joe@perches.com>,
        <rickveens92@gmail.com>, <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtlwifi: Removed unused define and code efuse_re_pg* from wifi.h
References: <20181001090424.13862-1-pkshih@realtek.com>
Date:   Mon, 01 Oct 2018 12:10:36 +0300
In-Reply-To: <20181001090424.13862-1-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Mon, 1 Oct 2018 17:04:24 +0800")
Message-ID: <87r2ha2fsj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<pkshih@realtek.com> writes:

> From: Rick Veens <rickveens92@gmail.com>
>
> The following:
>  bool efuse_re_pg_sec1flag;
>  u8 efuse_re_pg_data[8];
> are not referenced anywhere in the rtlwifi code.
>
> This patch is originally created by Rick Veens <rickveens92@gmail.com>,
> and Joe Perches <joe@perches.com> reminded to apply it to rtlwifi.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Rick's Signed-off-by is missing. Ping, either you need to mark yourself
as author (which IMHO is correct as you wrote this patch anyway, Rick
wrote it for the other driver) or Rick needs to give his s-o-b.

-- 
Kalle Valo
