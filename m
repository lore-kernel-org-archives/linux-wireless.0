Return-Path: <SRS0=/TLA=3P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAB2C2D0DB
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 15:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10282083E
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 15:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="d7MosDhz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAZPhj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jan 2020 10:37:39 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:62669 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgAZPhi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jan 2020 10:37:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053058; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tBU8Uq94ftDlFrdFbNa6uWBRnB5YjHCwgAn1hwClKIs=;
 b=d7MosDhzsxoitoTtkR4mvWv5edRS5+7oRaHKZszxkmALN+Nx2esKrDugJZRIPhXBALLSplbi
 tzR/Qjsxl3PfyGf0pRqvVY3x/gaVgRisvJHYTAxV04XCER4f0YfSWXGvuVNFzg0EhOjn8VsJ
 0mOimn4nioN1Uja3G4ev3C4kwLs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db23b.7fd23874d0d8-smtp-out-n01;
 Sun, 26 Jan 2020 15:37:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BD540C433A2; Sun, 26 Jan 2020 15:37:31 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF184C43383;
        Sun, 26 Jan 2020 15:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF184C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/7] rtw88: pci: reset ring index when release skbs in
 tx ring
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191219085816.20709-2-yhchuang@realtek.com>
References: <20191219085816.20709-2-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>,
        <chiu@endlessm.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126153731.BD540C433A2@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:37:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Chin-Yen Lee <timlee@realtek.com>
> 
> When skbs queued for each TX ring are relased in PCI stop flow,
> the ring index should be reset at the same time.
> 
> Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

7 patches applied to wireless-drivers-next.git, thanks.

25cab7e71da3 rtw88: pci: reset ring index when release skbs in tx ring
fd30e891e0bc rtw88: pci: reset dma when reset pci trx ring
786221048e8f rtw88: add interface config for 8822c
c8e5695eae99 rtw88: load wowlan firmware if wowlan is supported
44bc17f7f5b3 rtw88: support wowlan feature for 8822c
e3e400df3007 rtw88: Add wowlan pattern match support
b6c12908a33e rtw88: Add wowlan net-detect support

-- 
https://patchwork.kernel.org/patch/11302855/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
