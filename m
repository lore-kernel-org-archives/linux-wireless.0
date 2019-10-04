Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC562C4360C
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE6FE20873
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k0yKs3yX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lw6xUodu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388543AbfJDNpl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:45:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbfJDNpl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:45:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5303761A41; Fri,  4 Oct 2019 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196740;
        bh=jjtSBgHBMuL6Z65eU5Sa2jOPwDNDnj8Bxh1IJnw7s2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=k0yKs3yXIsU/2qFZFC2k9+gsZPdSWhCyNQBjAr3cQzM6WygYHRvQLKN4ntZR5pMAW
         OY5BbWY5mcmAmGOcGJs8Lj4CBT1ZESC4xn71KdsU59O+85mU3E56k2sKU/BKpbPpYf
         1qXKCNvzhiAr5IVRGlHsyiT8n3nGUQ6kTxoSvNro=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E0D8E613A8;
        Fri,  4 Oct 2019 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196739;
        bh=jjtSBgHBMuL6Z65eU5Sa2jOPwDNDnj8Bxh1IJnw7s2s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Lw6xUoduYqJ6nXfjGkyfNa65tOMQuQoS+oBjfMS9SVa/oK3GCaRIj+9DgHbkIZ2WT
         5RZgGcA1lnqRKCNUNdFr+eblcaVdf6xRYO7c89JnUGk5H2gE69NBRt3/FaeGh60CGS
         u5C/wGLlfzFpdZOFr40MkIfJhofdhzjScVaDw5ps=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E0D8E613A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/14] rtw88: check firmware leave lps successfully
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002063531.18135-2-yhchuang@realtek.com>
References: <20191002063531.18135-2-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191004134540.5303761A41@smtp.codeaurora.org>
Date:   Fri,  4 Oct 2019 13:45:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Chin-Yen Lee <timlee@realtek.com>
> 
> Driver needs to wait for firmware to restore hardware setting
> to active mode after leaving lps.
> 
> After getting H2C from driver for leaving lps, firmware will
> issue null packet without PS bit to inform AP driver is active,
> and then restore REG_TCR Register if AP has receiced null packet.
> 
> But the transmission of null packet may cost much more time
> in noisy environment. If driver does not wait for firmware,
> null packet with PS bit could be sent due to incorrect REG_TCR setting.
> And AP will be confused.
> 
> In our test, 100ms is enough for firmware to send null packet
> to AP. If REG_TCR Register is still wrong after 100ms, we will
> modify it directly, force the PS bit to be cleared
> 
> Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

14 patches applied to wireless-drivers-next.git, thanks.

3a2dd6b7cadf rtw88: check firmware leave lps successfully
942e2a5d39a9 rtw88: allows to set RTS in TX descriptor
3745d3e550d1 rtw88: add driver TX queue support
46ebb1743f33 rtw88: take over rate control from mac80211
699c7730cf23 rtw88: report tx rate to mac80211 stack
127eef1d46f8 rtw88: add TX-AMSDU support
1131ad7fe575 rtw88: flush hardware tx queues
c3594559f49c rtw88: fix beaconing mode rsvd_page memory violation issue
0649ff58a0f6 rtw88: Don't set RX_FLAG_DECRYPTED if packet has no encryption
bf06c7ec4508 rtw88: configure TX queue EDCA parameters
bc3696e0a436 rtw88: raise firmware version debug level
cc20a7139836 rtw88: use struct rtw_fw_hdr to access firmware header
4f5bb7ff8b8d rtw88: fix NSS of hw_cap
f4268729eb1e rtw88: fix error handling when setup efuse info

-- 
https://patchwork.kernel.org/patch/11170463/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

