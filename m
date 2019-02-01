Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E033FC3E8A4
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08E221872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cpLRl5jw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MmC/uv3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfBAMQi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:16:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfBAMQi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:16:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D7DB26030D; Fri,  1 Feb 2019 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023396;
        bh=8frgMAbGrOj6TuPoEi3BLHfJPExy3KDLos5tq3XKau4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cpLRl5jw4TlTyNCdJeI2fDui0h+pF5wXpva/s4XZF4Zn/gY9XPx/gIe1QYtGsHS0f
         JYMUJ0ieeyjnqzyhDtmNecvlisNchIOhttJIVLy5L5g6bf2Q/Zr5uvg7xDNzVPBV9J
         GqCnMZtxh6PbzgtmKKZwrMRjda8OCp9lBYcXFMy8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D0776043F;
        Fri,  1 Feb 2019 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023396;
        bh=8frgMAbGrOj6TuPoEi3BLHfJPExy3KDLos5tq3XKau4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MmC/uv3Cr7Lj21blGhcv2Mwti1RtWrTdjww4JCqSA3m6xqz81Csz9qCFN7CgZEi7m
         bN4RVYmEMaVLKTASIBJb9a6acno/cfgbDfJp8QHC+wvnwANouHiDFhBGi1MUJ9F81X
         c+P7Sp2vZebu+up0ju97sJc6QCvlOAxJjC3kiw0g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D0776043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rt2x00: Work around a firmware bug with shared keys
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
References: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201121636.D7DB26030D@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:16:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> wrote:

> Apparently the rt2x61 firmware fails temporarily to decode
> broadcast packets if the shared keys are not assigned
> in the "correct" sequence. At the same time unicast
> packets work fine, since they are encrypted with the
> pairwise key.
> 
> At least with WPA2 CCMP mode the shared keys are
> set in the following sequence: keyidx=1, 2, 1, 2.
> After a while only keyidx 2 gets decrypted, and
> keyidx 1 is ignored, probably because there is never
> a keyidx 3.
> 
> Symptoms are arping -b works for 10 minutes, since
> keyidx=2 is used for broadcast, and then it stops
> working for 10 minutes, because keyidx=1 is used.
> That failure mode repeats forever.
> 
> Note, the firmware does not even know which keyidx
> corresponds to which hw_key_idx so the firmware is
> trying to be smarter than the driver, which is bound
> to fail.
> 
> As workaround the function rt61pci_config_shared_key
> requests software decryption of the shared keys,
> by returning EOPNOTSUPP. However, pairwise keys are
> still handled by hardware which works just fine.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

a4296994eb80 rt2x00: Work around a firmware bug with shared keys

-- 
https://patchwork.kernel.org/patch/10764543/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

