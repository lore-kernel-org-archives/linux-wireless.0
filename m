Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C91C04AB6
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 11:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8909220717
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 11:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cSuRdDH2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ph1XyTeF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfE1LvF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 07:51:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfE1LvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 07:51:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C28C860A33; Tue, 28 May 2019 11:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559044264;
        bh=uHgyjXhdBxPyrqxB5Ywri5s3koSwbiC4Qi0x6gXswYY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cSuRdDH2soKiyEybRkiVm86CncDblP0RquGKMeSGBMftL1XWr+UUUdt38ZMD0wm68
         6T+Uq9nISsJJZ8DSmF/CGniq1y25kFhM8HAzwSUqW5IWBkYPVbTTdPnTXf8I9W/gBi
         fRG/xCn0lcRJj9gng0x4ImlwkEklXtFc8hTEBAIo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1ED0860769;
        Tue, 28 May 2019 11:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559044264;
        bh=uHgyjXhdBxPyrqxB5Ywri5s3koSwbiC4Qi0x6gXswYY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ph1XyTeFhopsKfdcjbQRfzBCer4K387vJY3qPMV9Cgih4RVE0AGDrrcybDfvu8TFR
         r/JFgnFUoQ5r1w2aCAfTu5XcNWSocM5bvhHZkWqJcmR5y+KTIv3xZiF4GeFEGsNjVP
         NPP+zuEey7rvi+ed+GiJmVSt/giicalLr/usCx00=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1ED0860769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/5] rtw88: pci: use ieee80211_ac_numbers instead of 0-3
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1556884415-23474-3-git-send-email-yhchuang@realtek.com>
References: <1556884415-23474-3-git-send-email-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528115104.C28C860A33@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:51:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> AC numbers are defined as enum in mac80211, use them instead of bare
> 0-3 indexing.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

3 patches applied to wireless-drivers-next.git, thanks.

82dea406c509 rtw88: pci: use ieee80211_ac_numbers instead of 0-3
0d7882950c73 rtw88: pci: check if queue mapping exceeds size of ac_to_hwq
a3b0c66c5928 rtw88: more descriptions about LPS

-- 
https://patchwork.kernel.org/patch/10928423/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

