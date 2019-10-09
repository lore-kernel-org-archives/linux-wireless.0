Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23B4ECE58D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 08:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66832133F
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 08:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lW190IE+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MsO/SH/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfJIIXO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 04:23:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJIIXO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 04:23:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F072761C0B; Wed,  9 Oct 2019 08:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609393;
        bh=+ER2l7QyQqmRjgzsuJZtEAcUaI+MNTnPl4Iq9yddUeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lW190IE+SqzCfpgxmpy5I/gHXPFCPenRX34PtcU+KepFOh79cLwys7K0J0OFNRovG
         xK8H5DEp4dWlJZjwea+E60Blwg0q8k3owTKFP9L4TCTg2atmvOTDnOCBhwa9BXdNYd
         0+kzOUPvxcaeecJwjin+qpffH+cgJrSVfmDz6rxI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 58A9361C0B;
        Wed,  9 Oct 2019 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609391;
        bh=+ER2l7QyQqmRjgzsuJZtEAcUaI+MNTnPl4Iq9yddUeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MsO/SH/UYIPCWEu5cYUYLiTXC9cLsdfBZZ1XmVWYxXMYYesvaO/Ipf+OTG44d8AAa
         eg3X0C1BOMfgJ9RpGOp5xCRu/Fh9KDvK4CldEN5tGZYQsKMkKeedWjl0CahjulmRmq
         sB65Lmne+bYfJBdC5MCD2Bf0wIa5BpCZjWI3Ygak=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 58A9361C0B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rtlwifi: rtl8821ae: Remove set but not used variables
 'rtstatus', 'bd'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570178635-57582-2-git-send-email-zhengbin13@huawei.com>
References: <1570178635-57582-2-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082312.F072761C0B@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:23:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8812ae_phy_config_rf_with_headerfile:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2079:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8821ae_phy_config_rf_with_headerfile:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2114:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function _rtl8812ae_phy_get_txpower_limit:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2354:6: warning: variable bd set but not used [-Wunused-but-set-variable]
> 
> They are not used since commit f1d2b4d338bf ("rtlwifi:
> rtl818x: Move drivers into new realtek directory")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

8 patches applied to wireless-drivers-next.git, thanks.

0fc44cd4c480 rtlwifi: rtl8821ae: Remove set but not used variables 'rtstatus','bd'
a3e017fd8932 rtlwifi: rtl8723ae: Remove set but not used variables 'reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
a003aec306c8 rtlwifi: rtl8192c: Remove set but not used variables 'reg_ecc','reg_eac'
925942b5da09 rtlwifi: rtl8188ee: Remove set but not used variables 'v3','rtstatus','reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
073f8138f598 rtlwifi: rtl8188ee: Remove set but not used variable 'h2c_parameter'
e25076070201 rtlwifi: btcoex: Remove set but not used variable 'result'
aab7541a5a8b rtlwifi: btcoex: Remove set but not used variables 'wifi_busy','bt_info_ext'
4614239cba34 rtlwifi: rtl8723: Remove set but not used variable 'own'

-- 
https://patchwork.kernel.org/patch/11173861/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

