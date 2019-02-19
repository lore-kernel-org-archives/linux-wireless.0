Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1B7C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DDBB2081B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UvdMlO5o";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SbQ5ffT3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfBSPEK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:04:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59000 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBSPEJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:04:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C6D7608CE; Tue, 19 Feb 2019 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588648;
        bh=m376SzncSDfKYXCY4FuM2jX6sqwile35bwZGS4L9OUk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UvdMlO5o77l1Nhy1TQcE54NYGxBshDKzlZJ5cUEUD/C5O5x4XkDsXjuMRUj/oJ0oV
         OntqM7V2+xR4QqJs/k+7tnTBxxCwq0HW9tp9SBg8k3FUMrZW87/aTMF9wuDps9/2lY
         uRnB9QRopOkLoD/qsOjLAIp/4d/xHn8TA7mtcsZs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9B146071A;
        Tue, 19 Feb 2019 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588646;
        bh=m376SzncSDfKYXCY4FuM2jX6sqwile35bwZGS4L9OUk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SbQ5ffT3Zc2SYEcqmvLcLPVsrU+KM8Ega6Gp0x0KllYUipRPimd0p78Vx4VMAoyMV
         3NR0eAmjutFsOtBsTBjl0Qj61syjk6JM0X2rAXrWy/G/qE+wsIQyrSkjcBbcLj7KZ1
         JZCyHdH6ptb39SQs8eJ/E06XUvAEckGG7APRkYis=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D9B146071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rtlwifi: Remove CamelCase variables from base code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190214223644.8035-2-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150408.1C6D7608CE@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:04:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> There are a number of CamelCase variables remaining in the source
> files of modules rtl_pci, rtl_usb, and rtlwifi.
> 
> The following checkpatch excettions are also fixed:
> 
> for_kalle1/0001-rtlwifi-Remove-CamelCase-variables-from-base-code.patch
> -----------------------------------------------------------------------
> CHECK: Unnecessary parentheses around 'rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
>                              rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]'
> #68: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:377:
> +                       if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
> +                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]) ||
> +                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
> +                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
>                                                                    1])) {
> 
> CHECK: Unnecessary parentheses around 'rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
>                              rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
>                                                                    1]'
> #68: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:377:
> +                       if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
> +                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]) ||
> +                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
> +                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
>                                                                    1])) {
> 
> WARNING: line over 80 characters
> #70: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:379:
> +                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
> 
> CHECK: No space is necessary after a cast
> #186: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:396:
> +       status->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
> 
> CHECK: No space is necessary after a cast
> #208: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c:335:
> +       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
> 
> CHECK: No space is necessary after a cast
> #243: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:301:
> +       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
> 
> CHECK: No space is necessary after a cast
> #252: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:368:
> +       stats.rx_is40mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
> 
> CHECK: No space is necessary after a cast
> #265: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c:475:
> +       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
> 
> WARNING: Unnecessary space before function pointer arguments
> #455: FILE: drivers/net/wireless/realtek/rtlwifi/wifi.h:1462:
> +       void (*writen_sync) (struct rtl_priv *rtlpriv, u32 addr, void *buf,
> 
> WARNING: Unnecessary space before function pointer arguments
> #483: FILE: drivers/net/wireless/realtek/rtlwifi/wifi.h:2257:
> +       void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pdesc,
> 
> Note that not all checkpatch exceptions are addressed. Those will be
> handled in later patches.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

8 patches applied to wireless-drivers-next.git, thanks.

e703c5dd2d69 rtlwifi: Remove CamelCase variables from base code
2171def56daf rtlwifi: btcoexist: Remove CamelCase variable
d420110635ad rtlwifi: rtl8188ee: Remove CamelCase variable
ff9704538e6d rtlwifi: rtl8192{c,u}: Remove CamelCase variables
b83faeda028b rtlwifi: rtl8188de: Remove CamelCase variables
2a83ad1fe330 rtlwifi: rtl8192se: Remove CamelCase variables
92a1aa25c782 rtlwifi: rtl8723{be,ae}: Remove CamelCase variables
9c66a7e5d39c rtlwifi: rtl8821ae: Remove CamelCase variables

-- 
https://patchwork.kernel.org/patch/10813947/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

