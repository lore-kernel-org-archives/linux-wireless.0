Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE0EC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CDEF206B6
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A3wQblgD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GgXRAVXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfAGNbu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:31:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfAGNbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:31:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5ECBC60303; Mon,  7 Jan 2019 13:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867909;
        bh=qYgWmQjBZ07VNkThjVNt5fnj2NRcYxS/lxVxoQsYbCE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A3wQblgDB264tyDqnJv1tyj6CuS4kFrG5+ZYUjnB3zGh5Z+FCwe580IJYldOAVppL
         KCERZJwL64F4zNWYUnfdU8a497rVReYE15RSBm5pUr4H9pr+pSieKBf4oYxoJKABqf
         Yn8M9DApl8DP8HEHMpCNYmOYMBAttkFNGzfP9mHE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1E7D5601D1;
        Mon,  7 Jan 2019 13:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867908;
        bh=qYgWmQjBZ07VNkThjVNt5fnj2NRcYxS/lxVxoQsYbCE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GgXRAVXVugrfcSd3n89zz4G675T0oeSMpuqgG3gFHGX9eGUve8IpiADKZh6TFhR0r
         vZ9KPKW5nUdG2BkZgNxn1lzdaX79ivozP/oS37Aok6GtdRoluT9UeZjrPGu4N/LTQs
         4BTNCnh7VuAypM/wzpt7n5dfSSn38KhUMTajwHyQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1E7D5601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org, nbd@nbd.name,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH v2] mt76: mmio: introduce mt76x02_check_tx_hang watchdog
References: <82a9efd24a70b701808d4ecd8ad2c8289463ae35.1546004654.git.lorenzo.bianconi@redhat.com>
        <201812290207.LUUmFHNB%fengguang.wu@intel.com>
        <87ef9o7i2n.fsf@purkki.adurom.net>
        <20190107132647.GA4645@localhost.localdomain>
Date:   Mon, 07 Jan 2019 15:31:44 +0200
In-Reply-To: <20190107132647.GA4645@localhost.localdomain> (Lorenzo Bianconi's
        message of "Mon, 7 Jan 2019 14:26:48 +0100")
Message-ID: <87sgy4sif3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> kbuild test robot <lkp@intel.com> writes:
>> 
>> > Hi Lorenzo,
>> >
>> > I love your patch! Yet something to improve:
>> >
>> > [auto build test ERROR on wireless-drivers-next/master]
>> > [also build test ERROR on next-20181224]
>> > [cannot apply to v4.20]
>> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>> >
>> > url:    https://github.com/0day-ci/linux/commits/Lorenzo-Bianconi/mt76-mmio-introduce-mt76x02_check_tx_hang-watchdog/20181228-224737
>> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
>> > config: i386-randconfig-sb0-12290140 (attached as .config)
>> > compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
>> > reproduce:
>> >         # save the attached .config to linux build tree
>> >         make ARCH=i386 
>> >
>> > All errors (new ones prefixed by >>):
>> >
>> >    In file included from drivers/net/wireless/mediatek/mt76/mt76x02.h:23:0,
>> >                     from drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:21:
>> >    drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c: In function 'mt76x02_watchdog_reset':
>> >>> drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:435:36: error: 'MT_TXOP_ED_CCA_EN' undeclared (first use in this function)
>> 
>> Didn't check the sources but looks like a valid error to me. Can you fix
>> this, please?
>
> Hi Kalle,
>
> This patch needs to be applied on top of 'add EDCCA support to mt76x{0,2}e drivers'
> series (https://patchwork.kernel.org/cover/10727149/). I forgot to
> point it out, sorry. However Felix has already applied them in the correct order,
> so nothing to do here.

Good to know, thanks.

-- 
Kalle Valo
