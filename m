Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA79C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E2D206BF
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GlYmLi5e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jzwZlSWb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfDZMJx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:09:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfDZMJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 08:09:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2CDBD60779; Fri, 26 Apr 2019 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556280592;
        bh=ee/ciKjh1vDz4eoAf/NSean9vfwlqobEKpmWVY0ZT8U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GlYmLi5eB7VE3aJfJ9RWdgf9IsLdndnEOD4j8p3dQ6wjwV5KbIzRcICgkRvcRgCik
         /oLEtp8IIjpjVufoW6Ku7dljugAXPD4psVA4bg8cc1vhapPBPvjNPGeCe1BjEIN8RY
         UNHuS+S7kjRJIbJLm/ezmBotUUNkDbZbJOX4ugAE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 727EF60736;
        Fri, 26 Apr 2019 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556280590;
        bh=ee/ciKjh1vDz4eoAf/NSean9vfwlqobEKpmWVY0ZT8U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jzwZlSWbdfW9J1Nh5+YgGoj5ZnT4faUVLgZqj1fTCYx2m80317/OOlrZWEvq/7bGs
         JEBmPlsBj7NoMgqBz3+gNyXUZmXzo+9bRR/nTilak+3hkw5DZGtd8B1tFSYAyYGMuV
         kr1gM1jgwGy6srg74mCdgS0QHpzy/7Xd8Vqbty5E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 727EF60736
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <Larry.Finger@lwfinger.net>, <sgruszka@redhat.com>,
        <briannorris@chromium.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi driver
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
        <1555653004-1795-15-git-send-email-yhchuang@realtek.com>
Date:   Fri, 26 Apr 2019 15:09:46 +0300
In-Reply-To: <1555653004-1795-15-git-send-email-yhchuang@realtek.com>
        (yhchuang@realtek.com's message of "Fri, 19 Apr 2019 13:50:04 +0800")
Message-ID: <87d0l9ufw5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> writes:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> series driver rtw88, remove it to avoid racing with the same ID.
>
> The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

BTW, this patch does not apply to wireless-drivers-next anymore. To
avoid any conflicts, would be it be safer that the driver is removed
directly from Greg's tree? After rtw88 is applied to
wireless-drivers-next, of course.

error: patch failed: drivers/staging/rtlwifi/Kconfig:1
error: drivers/staging/rtlwifi/Kconfig: patch does not apply
error: patch failed: drivers/staging/rtlwifi/efuse.c:1
error: drivers/staging/rtlwifi/efuse.c: patch does not apply
error: patch failed: drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c:1
error: drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c: patch does not apply
error: patch failed: drivers/staging/rtlwifi/pci.h:1
error: drivers/staging/rtlwifi/pci.h: patch does not apply
error: patch failed: drivers/staging/rtlwifi/phydm/phydm_rainfo.c:1
error: drivers/staging/rtlwifi/phydm/phydm_rainfo.c: patch does not apply
error: patch failed: drivers/staging/rtlwifi/phydm/rtl_phydm.c:1
error: drivers/staging/rtlwifi/phydm/rtl_phydm.c: patch does not apply
error: patch failed: drivers/staging/rtlwifi/rtl8822be/fw.c:1
error: drivers/staging/rtlwifi/rtl8822be/fw.c: patch does not apply
Patch failed at 0014 staging: rtlwifi: remove staging rtlwifi driver

-- 
Kalle Valo
