Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E250C432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 12:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A612075C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 12:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UrAD6Zf6";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="QANq5Wge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfKYMgw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:36:52 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:32926
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbfKYMgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 07:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574685411;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=281uii2cHKHQ5RIaD5ZKrHTRFYPuwnG4BLOWdy+fJ0E=;
        b=UrAD6Zf6uPBvQqFry4GR0GT50X5MP2jwt7CKmT5pzccXMy1hqjPpgvcYbEV/sQS5
        /IUApepSQXlYUkGlssCUzcp2O66SmuZkl7PT4FgKFoxfrB8DZNY7d+X4yLHLbhPyvmg
        LPQYrsCILhBeogcbff/M8XTHMq0RQ1xmvoB4n9Zo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574685411;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=281uii2cHKHQ5RIaD5ZKrHTRFYPuwnG4BLOWdy+fJ0E=;
        b=QANq5WgesHckHWmPiAOiqakFbtFquFQ8nCyQSGoCeZ2qcXOo4F7+utJuNPkkAcLt
        lcYcp3/yWW6SpobW4nRd4snHWEBkfoki0syDdGr8zcaNA4S9SAQXMOQxNzPuhSl056Z
        BF29Z4645ZRfSdlx/cY3YoYeJtJyS6rDqfiu95us=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E032C447BB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     huangwenabc@gmail.com, kbuild-all@lists.01.org,
        linux-wireless@vger.kernel.org, linux-distros@vs.openwall.org,
        security@kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix two buffer overflows at parsing bss descriptor
References: <20191122052917.11309-1-huangwenabc@gmail.com>
        <201911241536.lyRxx5Oc%lkp@intel.com>
Date:   Mon, 25 Nov 2019 12:36:51 +0000
In-Reply-To: <201911241536.lyRxx5Oc%lkp@intel.com> (kbuild test robot's
        message of "Sun, 24 Nov 2019 15:52:03 +0800")
Message-ID: <0101016ea29086a5-c22d2a1c-29f0-4d6b-99c8-2632befdd1ab-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.25-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on wireless-drivers-next/master]
> [also build test WARNING on v5.4-rc8 next-20191122]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/huangwenabc-gmail-com/libertas-Fix-two-buffer-overflows-at-parsing-bss-descriptor/20191124-142236
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=sh 
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/marvell/libertas/cfg.c: In function 'lbs_ibss_join_existing':
>>> drivers/net/wireless/marvell/libertas/cfg.c:1788:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

I was wondering why I didn't see this mail in patchwork:

https://patchwork.kernel.org/patch/11257187/

And then I noticed this:

X-Patchwork-Hint: ignore

kbuild team, why are you adding that header? It's really bad for a
maintainer like me who uses patchwork actively, it means that all these
important warnings are not visible in patchwork and can be easily missed
by the maintainers.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
