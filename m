Return-Path: <SRS0=d+R+=CQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10E5C433E2
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 08:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A26208C7
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 08:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lV2RQWaI";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Dr8GOjQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgIGI3g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:29:36 -0400
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:47292
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbgIGI3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Sep 2020 04:29:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467374;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=9xmQDpOP5iANBlM3ftlWzlsH00WaOADPBTmWJq3fQoQ=;
        b=lV2RQWaISNpmNCgbvYVawVCIrDbsFkie0ZCARMNf0MCeHUjJDlEK+nlMGUYVmqzf
        +EEAE2qiS3MwBYPEBF002O0DavKsF/8qWybZEFiWp6+Sv6TEykRhKoiIMffscwONE+z
        G5Yc1g0+QWLhS6QzadBt2guLKCgGJUqKn1oKztiU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467374;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=9xmQDpOP5iANBlM3ftlWzlsH00WaOADPBTmWJq3fQoQ=;
        b=Dr8GOjQ/BWGI+PQlcK9vrwCtRSv8Hsn64jt0g2QQIPp/iFjvL5WzS6w6gajqzMWG
        kqWf/7ZhXFWcOs05Ak6ajqF/wMUnCngxjtjziBpyUyaVdXgJBC7Pt1wMc2a9mRM0iny
        ZP8ADKjHGSahgB8MWG/8YNYk7k2t9iLHClOoIkHo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA80DC4345B
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Remove unnecessary braces from
 HostCmd_SET_SEQ_NO_BSS_INFO
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200901070834.1015754-1-natechancellor@gmail.com>
References: <20200901070834.1015754-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andy Lavr <andy.lavr@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467af484e-3cb25a00-4120-4134-a519-be68ab3a49ca-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:29:34 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> A new warning in clang points out when macro expansion might result in a
> GNU C statement expression. There is an instance of this in the mwifiex
> driver:
> 
> drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
> ')' tokens terminating statement expression appear in different macro
> expansion contexts [-Wcompound-token-split-by-macro]
>         host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/fw.h:519:46: note: expanded from
> macro 'HostCmd_SET_SEQ_NO_BSS_INFO'
>         (((type) & 0x000f) << 12);                  }
>                                                     ^
> 
> This does not appear to be a real issue. Removing the braces and
> replacing them with parentheses will fix the warning and not change the
> meaning of the code.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1146
> Reported-by: Andy Lavr <andy.lavr@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Patch applied to wireless-drivers-next.git, thanks.

6a953dc4dbd1 mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO

-- 
https://patchwork.kernel.org/patch/11747495/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

