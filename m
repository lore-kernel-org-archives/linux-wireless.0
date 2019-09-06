Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C61C43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB11220842
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 14:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ODT4nL9o";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ndRYLN36"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394065AbfIFOPF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 10:15:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731458AbfIFOPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E63556083C; Fri,  6 Sep 2019 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779303;
        bh=GepNkH7eQ+FB4JbQO2IsH9dhMgSlA4mi3GxEmrfpKH8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ODT4nL9oxIdtfXPHE9XLg3IGm+VDG/iDAaH9RwsA/ob7V4nd2Pc1SB7EUqY3lM63N
         XNX0TrpgalUJ27oxuHn1GzTcM/oBFf1uYiYxX1jSzQ4EBFj4/C+Dxd2zDzmvU3GkR9
         5WYetTy6FlNoKfqA46ojUITrDAykd5dXlwTvze+0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 73AC66030B;
        Fri,  6 Sep 2019 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779303;
        bh=GepNkH7eQ+FB4JbQO2IsH9dhMgSlA4mi3GxEmrfpKH8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ndRYLN36aoMEpY575XusvmnPzfg/u6kbOQ7DW7lNfIc99vpxE7H/KEC+88tqVxQYZ
         phyezZ3nQXmMnXmNeswgLCFmcD742UORY6YcUlBA2MB9gBGrg3jXJ+bzo68BuRJtor
         VoxF86dg7cLtENdWWC9B0yBEnaIZfADSLXHorNwk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 73AC66030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] brcmfmac: use %*ph to print small buffer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190904175052.77596-1-andriy.shevchenko@linux.intel.com>
References: <20190904175052.77596-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190906141503.E63556083C@smtp.codeaurora.org>
Date:   Fri,  6 Sep 2019 14:15:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied to wireless-drivers-next.git, thanks.

0e48b86d9a8f brcmfmac: use %*ph to print small buffer

-- 
https://patchwork.kernel.org/patch/11131189/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

