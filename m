Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734ACC282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 03:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404732075B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 03:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GQkN3Gah";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GQkN3Gah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDPDgx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 23:36:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfDPDgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 23:36:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C73E7608D4; Tue, 16 Apr 2019 03:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555385811;
        bh=l0tY0NqVwdKLYiFp6PZGQV9aQNteT7tjL8QZIZ6IJhA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GQkN3Gahycr9yPm776IJQlgwitoDd/YeNWmAY6Auls46/7fshM0TCn5QuCmVp1JRL
         llqza70Hv0jXEsz2K97grbOQhBGIB20143tEuB7pxy5vHDcKyM/+RWz/osoQn+8dk4
         3oeOPpGRihJZvg9lHIusxfZvq0zYfuANdrI7TxIg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81428608D4;
        Tue, 16 Apr 2019 03:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555385811;
        bh=l0tY0NqVwdKLYiFp6PZGQV9aQNteT7tjL8QZIZ6IJhA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GQkN3Gahycr9yPm776IJQlgwitoDd/YeNWmAY6Auls46/7fshM0TCn5QuCmVp1JRL
         llqza70Hv0jXEsz2K97grbOQhBGIB20143tEuB7pxy5vHDcKyM/+RWz/osoQn+8dk4
         3oeOPpGRihJZvg9lHIusxfZvq0zYfuANdrI7TxIg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81428608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH wireless-drivers] rtlwifi: rtl8723ae: Fix missing break in switch statement
References: <20190416003626.GA16834@embeddedor>
Date:   Tue, 16 Apr 2019 06:36:46 +0300
In-Reply-To: <20190416003626.GA16834@embeddedor> (Gustavo A. R. Silva's
        message of "Mon, 15 Apr 2019 19:36:26 -0500")
Message-ID: <87h8ay8vu9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Add missing break statement in order to prevent the code from falling
> through to case 0x1025, and erroneously setting rtlhal->oem_id to
> RT_CID_819X_ACER when rtlefuse->eeprom_svid is equal to 0x10EC and
> none of the cases in switch (rtlefuse->eeprom_smid) match.
>
> This bug was found thanks to the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> Fixes: 238ad2ddf34b ("rtlwifi: rtl8723ae: Clean up the hardware info routine")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

You have marked this for wireless-drivers but the commit is 2.5 years
old, so I think wireless-drivers-next is more approriate.

-- 
Kalle Valo
