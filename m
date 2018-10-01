Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624A8C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B4620666
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Be3vn83i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QOyzkC6g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26B4620666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbeJAWPc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:15:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJAWPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:15:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6C74A601A0; Mon,  1 Oct 2018 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408229;
        bh=D4SlnN/62a+Lcq2zZCZ51I9SJI834sWKqoEkezb1NNk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Be3vn83itsRAGLqWjt5YmerymyLIhtqiFpHJEqNSm/d06TWxXRDN8iTVQv9gAUajT
         vjpjpmz72c8cw72nXP02ZQzO/sv8RPhN+WsGbXg9Jj8757L9mM5HgyzzEoOrdkdjqj
         D6bKVnlo9TZ9KBsq/+TaETh2sJ8X6XK1jWHatpto=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A6A860116;
        Mon,  1 Oct 2018 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408228;
        bh=D4SlnN/62a+Lcq2zZCZ51I9SJI834sWKqoEkezb1NNk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QOyzkC6gs4MQslf0A1G7bPGoTvYUVgU0NEZKySTHH2jA2b9SBEOrqBWVXjZYOQ7OB
         3j+bj1pQsj2fWgg8LRLIG1IO7vcpBvPYkZQlLCoLmmyaRpgAe6YkFbvbAew2FJghPT
         X8nMmxjq+v1WdBs1k0UMkWrxSd6MfieLz11pjDGs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A6A860116
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: btcoex: Use proper enumerated types for Wi-Fi
 only interface
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180923063114.11446-1-natechancellor@gmail.com>
References: <20180923063114.11446-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001153709.6C74A601A0@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:37:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns when one enumerated type is implicitly converted to another.
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1327:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_PCI;
>                                              ~ ^~~~~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1330:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_USB;
>                                              ~ ^~~~~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1333:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_UNKNOWN;
>                                              ~ ^~~~~~~~~~~~~~~~
> 3 warnings generated.
> 
> Use the values from the correct enumerated type, wifionly_chip_interface.
> 
> BTC_INTF_UNKNOWN = WIFIONLY_INTF_UNKNOWN = 0
> BTC_INTF_PCI = WIFIONLY_INTF_PCI = 1
> BTC_INTF_USB = WIFIONLY_INTF_USB = 2
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/135
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

31138a827d1b rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface

-- 
https://patchwork.kernel.org/patch/10611603/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

