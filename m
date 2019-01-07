Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05956C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0312183E
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 12:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gnH5p2bI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="niXbA0QM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfAGMoz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:44:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbfAGMoy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 07:44:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9DB63608FC; Mon,  7 Jan 2019 12:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546865093;
        bh=PGyJcowGagMvo26szjiiUyLZB1aRvAXqNiIMcdpcqdI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gnH5p2bIHDUzBjPtONbUjMSjGcW8qYeZWi8jnMRf/i2c7PPScU471YGwD+cc+YDx/
         hTVgouxegiMamZsxueEtkUMNngOGidLF+S7+pp/cl8CceJ7ZmffATaVJnRMuseTiXk
         Wf+QwkyDjcY9DSdeLcwhmbKHeIPFICT8dyUVaLhI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2C91608D4;
        Mon,  7 Jan 2019 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546865092;
        bh=PGyJcowGagMvo26szjiiUyLZB1aRvAXqNiIMcdpcqdI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=niXbA0QMDzN3cfEIXoOQJxa05XLySK7ZnYoU0FIDoVZrkOjA1XxzITwGIldMaLW0w
         pA+co+kwwyszmBijbHmCHqfecqjzvu5D2FNaXjhP1GA0Hsg2Gp2PezaSk7VN8ybXkx
         ar5V0GctD9ABH82Sm5whmV0si7cgJocHNtnexNDs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2C91608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, kbuild-all@01.org,
        nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH v2] mt76: mmio: introduce mt76x02_check_tx_hang watchdog
References: <82a9efd24a70b701808d4ecd8ad2c8289463ae35.1546004654.git.lorenzo.bianconi@redhat.com>
        <201812290207.LUUmFHNB%fengguang.wu@intel.com>
Date:   Mon, 07 Jan 2019 14:44:48 +0200
In-Reply-To: <201812290207.LUUmFHNB%fengguang.wu@intel.com> (kbuild test
        robot's message of "Sat, 29 Dec 2018 02:50:40 +0800")
Message-ID: <87ef9o7i2n.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

> Hi Lorenzo,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on next-20181224]
> [cannot apply to v4.20]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Lorenzo-Bianconi/mt76-mmio-introduce-mt76x02_check_tx_hang-watchdog/20181228-224737
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: i386-randconfig-sb0-12290140 (attached as .config)
> compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
>
> All errors (new ones prefixed by >>):
>
>    In file included from drivers/net/wireless/mediatek/mt76/mt76x02.h:23:0,
>                     from drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:21:
>    drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c: In function 'mt76x02_watchdog_reset':
>>> drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:435:36: error: 'MT_TXOP_ED_CCA_EN' undeclared (first use in this function)

Didn't check the sources but looks like a valid error to me. Can you fix
this, please?

-- 
Kalle Valo
