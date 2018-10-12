Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F357AC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78B720835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iDly5EFQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cs+nuO1k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A78B720835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbeJLWFS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 18:05:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728646AbeJLWFR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 18:05:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 03C4560C85; Fri, 12 Oct 2018 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354755;
        bh=hYvVpgGcuBZ0HuSt3BtryAsaHl5OV2O7jAS0YP34FXM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iDly5EFQQJeXRgi1cgPsGIBaCihdyNL3M/R+Z+Cy7JjVKOu4OqVPdrE7ev+NuvN3B
         ZZVSb4Pto453KI9Yg3CQuX4CWN8zOvnVHF5w4vLdg4rtVqeWOFYr4GCci+6n32AZCe
         VdbIsbhEy02PQxfsr9UCan45JCP1osO+nNkqtWoI=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3F7186024C;
        Fri, 12 Oct 2018 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354754;
        bh=hYvVpgGcuBZ0HuSt3BtryAsaHl5OV2O7jAS0YP34FXM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cs+nuO1kwfLPcsv2pSrXFQDWOfQQCw3WW/cXsxx+V/q07iEL8wSY9AfV6p99UwG/y
         y3WUe4GBDhIuvdpopRvgYu77X+LjIcagMxqjZKr0HmhLDIyJdb4rhF5p6Y6Lcmtk9a
         ExbthILy3CBC6vEh+mfP/wEUtvNbiOyU1jbZ7LZo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F7186024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, kbuild-all@01.org,
        ath10k@lists.infradead.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>,
        linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [ath6kl:pending 10/15] ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
References: <201810090804.eQbqAwdi%fengguang.wu@intel.com>
Date:   Fri, 12 Oct 2018 17:32:29 +0300
In-Reply-To: <201810090804.eQbqAwdi%fengguang.wu@intel.com> (kbuild test
        robot's message of "Tue, 9 Oct 2018 08:21:06 +0800")
Message-ID: <87pnwf44n6.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless, arnd

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git pending
> head:   70aa9eaba2a46b3d53caf03060576a7615182814
> commit: 108924d7a14299b2bcced255feb14bfdde7cb9d4 [10/15] ath10k: Fill
> the channel survey results for WCN3990 correctly
> config: parisc-allmodconfig (attached as .config)
> compiler: hppa-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 108924d7a14299b2bcced255feb14bfdde7cb9d4
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.2.0 make.cross ARCH=parisc 
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!

I'm not sure what this is about. The corresponding patch is here:

https://patchwork.kernel.org/patch/10624567/

I see some division in the patch but I can't immeaditely see what's
wrong. So is this a problem in the bot, in parisc architecture or with
the patch? Anyone have any good ideas? Arnd?

-- 
Kalle Valo
